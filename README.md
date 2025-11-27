# GitHub Actions for DataStage NextGen DevOps

A container and GitHub Actions definitions for MCIX  for IBM Cloud Pak DataStage (http://mcix.mettleci.com)

The defaultaction invokes the [mcix system version](https://nextgen.mettleci.io/mettleci-cli/system-namespace/#version) command.

## Inputs

None.

## Rules

None.

## Outputs

None.

## Usage

```yaml
- name: MCIX system version action
  uses: actions/mcix@v1
  # No arguments needed
```