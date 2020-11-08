#!/usr/bin/env groovy

def nodes = [:]

nodesByLabel('test1').each {
  nodes[it] = { ->
    node(it) {
      stage("docker-prune@${it}") {
        //branch = sh(script:"df -h / | grep -iv Filesystem | awk '{print$5}' | awk -F % '{print1}'",returnStdout:true).trim()
        cmdFillFindPs = 'df -h / | grep -iv Filesystem | awk \'{print$5}\''
        runPs = sh(returnStdout: true, script: cmdFillFindPs).trim()
        runPs = runPs.split('%')
        int filesystem_use = runPs[0] as int
        if (filesystem_use >= 70){
            sh('docker system prune -f --volumes')
            sh('docker image prune -af --filter "until=15m"')
        } else{
            println "clear"
        }
      }
    }
  }
}

parallel nodes
