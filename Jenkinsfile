#!/usr/bin/env groovy

def nodes = [:]

nodesByLabel('master', 'test1').each {
  nodes[it] = { ->
    node(it) {
      stage("docker-prune@${it}") {
        cmdFillFindPs = 'df -h / | grep -iv Filesystem | awk \'{print$5}\''
        runPs = sh(returnStdout: true, script: cmdFillFindPs).trim()
        runPs = runPs.split('%')
        int filesystem_use = runPs[0] as int
        if (filesystem_use >= 70){
            sh('docker system prune -f --volumes')
            sh('docker image prune -af --filter "until=15m"')
        } else{
            sh(returnStdout: true, script: "hostname").trim()
        }
      }
    }
  }
}

parallel nodes
