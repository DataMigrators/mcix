# mcix unit-test generate GitHub action

This action invokes the [mcix unit-test generate](https://nextgen.mettleci.io/mettleci-cli/unit-test-namespace/#generate) command.

## Inputs

## Rules

**Required** Path to the compliance rules. Default `/app/rules`.

## Path
        description: 'Path to the DataStage assets to analyze'
        required: false
        default: /app/datastage
## Report
        description: 'JUnit report file path'
        required: false
        default: /app/asset_analysis_report.xml
## Test-suite
        description: 'Test suite name'
        required: false
        default: 'mcix tests'

## Ignore-test-failures

Ignore test failures (always return 0)

## Include-job-in-test-name
Include job name in test name

## Outputs

## `output`

The console output of the mcix asset-analysis test command.

## Example usage

