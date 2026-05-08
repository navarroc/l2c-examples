process RUN_CONTAINER {
    container 'docker://hub.ncsa.illinois.edu/farmdoc/l2c-example-1:amd64'
    containerOptions '--workdir /app'

    cpus 1
    memory '4 GB'
    time '5m'

    script:
    """
    cd /app
    ./run_tool.sh
    """
}

workflow {
    // Debugging statements
    println("*****************************************************")
    println "launchDir: ${launchDir}"
    println "projectDir: ${projectDir}"
    println "workDir: ${workDir}"
    println("*****************************************************")
    RUN_CONTAINER()
}

