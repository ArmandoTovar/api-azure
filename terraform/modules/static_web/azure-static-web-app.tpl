name: Azure Static Web Apps CI/CD

on:
  push:
    branches:
      - main
  pull_request:
    types: [opened, synchronize, reopened, closed]
    branches:
      - main

jobs:
  build_and_deploy_job:
    if: github.event_name == 'push' || (github.event_name == 'pull_request' && github.event.action != 'closed')
    runs-on: ubuntu-latest
    name: Build and Deploy Job
    steps:
      - uses: actions/checkout@v3
        with:
          submodules: true
          lfs: false
      - name: Build And Deploy
        id: builddeploy
        uses: Azure/static-web-apps-deploy@v1
        with:
          azure_static_web_apps_api_token: $${{ secrets.AZURE_STATIC_WEB_APPS_API_TOKEN }}
          repo_token: $${{ secrets.GITHUB_TOKEN }} # Used for Github integrations (i.e. PR comments)
          action: 'upload'
          # For more information regarding Static Web App workflow configurations, please visit: https://aka.ms/swaworkflowconfig
          app_location: ${ app_location } # App source code path
          output_location: ${ output_location } # Built app content directory - optional
        env:
          VITE_MSAL_CLIENT_ID: $${{ vars.VITE_MSAL_CLIENT_ID }}
          VITE_MSAL_TENANT_ID: $${{ vars.VITE_MSAL_TENANT_ID }}
          VITE_MSAL_REDIRECT_URI: $${{ vars.VITE_MSAL_REDIRECT_URI }}
          VITE_MSAL_SCOPE: $${{ vars.VITE_MSAL_SCOPE }}
          VITE_API_URL: $${{ vars.VITE_API_URL }}

  close_pull_request_job:
    if: github.event_name == 'pull_request' && github.event.action == 'closed'
    runs-on: ubuntu-latest
    name: Close Pull Request Job
    steps:
      - name: Close Pull Request
        id: closepullrequest
        uses: Azure/static-web-apps-deploy@v1
        with:
          azure_static_web_apps_api_token: $${{ secrets.AZURE_STATIC_WEB_APPS_API_TOKEN }}
          action: 'close'
