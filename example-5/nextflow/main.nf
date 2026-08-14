
params.output_name = "output-normal3.jpg"

process RUN_CONTAINER {
    container 'docker://hub.ncsa.illinois.edu/farmdoc/l2c-example-5:amd64'

    cpus 1
    memory '4 GB'
    time '5m'

    script:
    """
    orig_dir=\$PWD
    cd /app && ./run_tool.sh eval --content-image images/content-images/amber.jpg --model saved_models/mosaic.pth --output-image "\$orig_dir/${params.output_name}"
    """
}

workflow {
    println("*****************************************************")
    println "launchDir: ${launchDir}"
    println "projectDir: ${projectDir}"
    println "workDir: ${workDir}"
    println("*****************************************************")
    RUN_CONTAINER()
}
