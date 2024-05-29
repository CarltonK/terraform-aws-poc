## Installation
    1. Install Terraform on your PC - I find it easier to use terraform version manager - https://github.com/tfutils/tfenv
    2. Install AWS Cli on your PC - https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
    3. Configure aws cli using ```aws configure``` command
    4. Inputs for (2) above
        https://docs.aws.amazon.com/cli/latest/userguide/cli-authentication-user.html
        In the IAM console, create a user, add the user to a group. Create Security Credentials for the user
        In the CLI, enter the Access Key ID and Secret Access Key
        Set region. I chose eu-central-1 because I love regions in the EU
        Output is one of text, csv or table


## Terraform CLoud
    1. Login to HCP Platform


## Workflow
    1. Commit to Branch
    2. This triggers a run in HCP depending on which workspace
        develop branch = dev workspace
        main branch = prod workspace
        

## IaaC.yaml
name: 'Infrastructure as Code with Terraform'
on:
  push:
    branches:
      - develop
      - main
  pull_request:
    branches:
      - develop
      - main
jobs:
  terraform:
    name: 'Terraform'
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: 1.8.4
          cli_config_credentials_token: ${{ secrets.TF_API_TOKEN }}

      - name: Skip run
        run: |
          exit 0

      - name: Set environment variables
        id: vars
        run: |
          if [ "${{ github.ref }}" == "refs/heads/main" ]; then
            echo "::set-output name=env::prod"
            echo "::set-output name=workspace_id::${{ secrets.PROD_WORKSPACE }}"
            echo "::set-output name=env_dir::environments/main"
          elif [ "${{ github.ref }}" == "refs/heads/develop" ]; then
            echo "::set-output name=env::dev"
            echo "::set-output name=workspace_id::${{ secrets.DEV_WORKSPACE }}"
            echo "::set-output name=env_dir::environments/develop"
          else
            echo "Branch not recognized. Exiting."
            exit 1
        shell: bash

      - name: Format
        id: fmt
        run: terraform -chdir=${{ steps.vars.outputs.env_dir }} fmt -check

      - name: Init
        id: init
        run: terraform -chdir=${{ steps.vars.outputs.env_dir }} init

      - name: Validate
        id: validate
        run: terraform -chdir=${{ steps.vars.outputs.env_dir }} validate -no-color

      - name: Plan
        id: plan
        if: github.event_name == 'pull_request'
        run: terraform -chdir=${{ steps.vars.outputs.env_dir }} plan -no-color
        continue-on-error: true

      - name: Update Pull Request
        uses: actions/github-script@0.9.0
        if: github.event_name == 'pull_request'
        env:
          PLAN: "terraform\n${{ steps.plan.outputs.stdout }}"
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          script: |
            const output = `#### Terraform Format and Style 🖌\`${{ steps.fmt.outcome }}\`
            #### Terraform Initialization ⚙️\`${{ steps.init.outcome }}\`
            #### Terraform Plan 📖\`${{ steps.plan.outcome }}\`
            #### Terraform Validation 🤖\`${{ steps.validate.outputs.stdout }}\`

            <details><summary>Show Plan</summary>

            \`\`\`\n
            ${process.env.PLAN}
            \`\`\`

            </details>

            *Pusher: @${{ github.actor }}, Action: \`${{ github.event_name }}\`*`;

            github.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: output
            })

      - name: Terraform Plan Status
        if: steps.plan.outcome == 'failure'
        run: exit 1

      - name: Trigger Terraform Cloud run
        env:
          TFC_TOKEN: ${{ secrets.TF_API_TOKEN }}
          WORKSPACE_ID: ${{ steps.vars.outputs.workspace_id }}
        run: |
          curl \
          --header "Authorization: Bearer $TFC_TOKEN" \
          --header "Content-Type: application/vnd.api+json" \
          --request POST \
          --data '{
            "data": {
              "attributes": {
                "message": "Triggered via GitHub Actions",
                "run_reason": "plan"
              },
              "type":"runs",
              "relationships": {
                "workspace": {
                  "data": {
                    "type": "workspaces",
                    "id": "'"${WORKSPACE_ID}"'"
                  }
                }
              }
            }
          }' \
          https://app.terraform.io/api/v2/runs
        