#!/usr/bin/env groovy
def labels = ['master', 'test1'] // labels for Jenkins node types we will build on
def nodes = [:]
for (label in labels) {
  //def label = x // Need to bind the label variable before the closure - can't do 'for (label in labels)
  // Create a map to pass in to the 'parallel' step so we can fire all the builds at once
  nodesByLabel(label).each {
    nodes[it] = { ->
      node(it) {
        stage("docker-prune@${it}") {
          if (label == 'test1'){
              cmdFillFindPs = 'df -h / | grep -iv Filesystem | awk \'{print$5}\''
          } else {
              cmdFillFindPs = 'df -h /var/lib/containers | grep -iv Filesystem | awk \'{print$5}\''
          }
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
}

parallel nodes
