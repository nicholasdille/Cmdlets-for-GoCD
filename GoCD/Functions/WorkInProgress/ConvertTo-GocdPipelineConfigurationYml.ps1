function ConvertTo-GocdPipelineConfigurationYml {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateScript( { $_.PSObject.TypeNames -contains 'GocdPipeline' } )]
        [pscustomobject]
        $Pipeline
    )

    $Configuration = Get-GocdPipelineConfiguration -Pipeline $Pipeline.Name

    "pipelines:"
    "  $($Configuration.name):"
    "    group: $($Pipeline.Group)"
    "    label_template: $($Configuration.label_template)"
    "    locking: $($Configuration.enable_pipeline_locking)"

    "    parameters:"
    if ($Configuration.parameters.Length -gt 0) {
        Write-Warning "Unable to process parameters in pipeline '$($Pipeline.Name)', group '$($Pipeline.Group)'"
    }

    "    environment_variables:"
    foreach ($Environment in $($Configuration.environment_variables | Where-Object { $_.secure -ieq 'False' })) {
        "      $($Environment.name): $($Environment.value)"
    }
    "    secure_variables:"
    foreach ($Environment in $($Configuration.environment_variables | Where-Object { $_.secure -ieq 'True' })) {
        "      $($Environment.name): [CANNOT BE RETRIEVED]"
    }

    "    materials:"
    foreach ($Material in $Configuration.materials) {
        $MaterialName = $Material.attributes.name

        if ($Material.type -ieq 'git') {
            if (-not $MaterialName) {
                $MaterialName = 'mygit'
            }
            "      $($MaterialName):"
            "        $($Material.type): $($Material.attributes.url)"
            "        branch: $($Material.attributes.branch)"
        
        } elseif ($Material.type -ieq 'dependency') {
            if (-not $MaterialName) {
                $MaterialName = 'mypipeline'
            }
            "      $($MaterialName):"
            "        pipeline: $($Material.attributes.pipeline)"
            "        stage: $($Material.attributes.stage)"

        } else {
            Write-Warning "Unknown material type '$($Material.type)' in pipeline '$($Pipeline.Name)', group '$($Pipeline.Group)'"
        }
    }

    "    stages:"
    foreach ($Stage in $Configuration.stages) {
        "      - $($Stage.name)"
        "          clean_workspace: $($Stage.clean_working_directory)"

        "    environment_variables:"
        foreach ($Environment in $($Stage.environment_variables | Where-Object { $_.secure -ieq 'False' })) {
            "      $($Environment.name): $($Environment.value)"
        }
        "    secure_variables:"
        foreach ($Environment in $($Stage.environment_variables | Where-Object { $_.secure -ieq 'True' })) {
            "      $($Environment.name): [CANNOT BE RETRIEVED]"
        }

        "          jobs:"
        foreach ($Job in $Stage.jobs) {
            "            $($Job.name):"

            "    environment_variables:"
            foreach ($Environment in $($Job.environment_variables | Where-Object { $_.secure -ieq 'False' })) {
                "      $($Environment.name): $($Environment.value)"
            }
            "    secure_variables:"
            foreach ($Environment in $($Job.environment_variables | Where-Object { $_.secure -ieq 'True' })) {
                "      $($Environment.name): [CANNOT BE RETRIEVED]"
            }

            "              resources:"
            foreach ($Resource in $Job.resources) {
                "                - $Resource"
            }

            "              artifacts:"
            foreach ($Artifact in $Job.artifacts) {
                "                - $($Artifact.type):"
                "                    source: $($Artifact.source)"
                "                    destination: $($Artifact.destination)"
            }

            "              tasks:"
            foreach ($Task in $Job.tasks) {
                "                - $($Task.type):"

                if ($Task.type -ieq 'exec') {
                    "                    command: $($Task.attributes.command)"
                    "                    arguments:"
                    foreach ($Argument in $Task.attributes.arguments) {
                        "                      - $Argument"
                    }

                } elseif ($Task.type -ieq 'fetch') {
                    "                    pipeline: $($Task.pipeline)"
                    "                    stage: $($Task.stage)"
                    "                    job: $($Task.job)"
                    "                    source: $($Task.source)"
                    "                    destination: $($Task.destination)"

                } elseif ($Task.type -ieq 'pluggable_task') {
                    "                    options: "
                    foreach ($Option in $Task.attributes.configuration) {
                        "                      $($Option.key): $($Option.value)"
                    }
                    "                    configuration:"
                    "                      id: $($Task.attributes.plugin_configuration.id)"
                    "                      verison: $($Task.attributes.plugin_configuration.version)"

                } else {
                    Write-Warning "Unable to process task of type '$($Task.type)' for pipeline '$($Pipeline.Name)', group '$($Pipeline.Group)'"
                    $Task | ConvertTo-Json | Write-Warning
                }
            }
        }
    }
}