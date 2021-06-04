try {
    node {
         def mavenHome
         def mavenCMD
         def docker
        def dockerCMD
        def tagName = "1.0"
         
         stage('Preparation') {
             echo "Preparing the Jenkins environment with required tools..."
             mavenHome = tool name: 'maven', type: 'maven'
             mavenCMD = "${mavenHome}/bin/mvn"
             docker = tool name: 'docker', type: 'org.jenkinsci.plugins.docker.commons.tools.DockerTool'
             dockerCMD = "$docker/bin/docker"
         }  
         stage('git checkout'){
            echo "Checking out the code from git repository..."
            git 'https://github.com/prabhat2020/batch10.git'
         }
        stage('Build, Test and Package'){
            echo "Building the addressbook application..."
            sh "${mavenCMD} clean package"
        }
        
        stage('Sonar Scan'){
            echo "Scanning application for vulnerabilities..."
            withSonarQubeEnv(credentialsId: 'sonarSecret') {
            sh "${mavenCMD} sonar:sonar"
            }
        }
        
        stage('App Scan') {
            step([$class: 'AppScanStandardBuilder', additionalCommands: '', authScanPw: '', authScanRadio: true, authScanUser: '', generateReport: true, includeURLS: '', installation: 'appScan', pathRecordedLoginSequence: '', policyFile: '', reportName: 'appScanReport', startingURL: 'http://34.126.185.123:8888/hello'])
        }
        
        stage('publish report'){
            echo " Publishing HTML report.."
            publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, includes: '*.xml', keepAll: true, reportDir: 'target/surefire-reports/', reportFiles: '*.xml', reportName: 'Spring Report', reportTitles: ''])
        }  
        
        stage('Build docker Image') {
            echo "Build docker image for spring application"
            sh "${dockerCMD} build -t prabhat2020/case1:${BUILD_NUMBER} ."
        }
        
        stage('Docker login and push') {
          withCredentials([string(credentialsId: 'dockerpswd', variable: 'dockerhubpwd')]) {
              sh "${dockerCMD} login -u prabhat2020 -p ${dockerhubpwd}"
            sh "${dockerCMD} push prabhat2020/case1:${BUILD_NUMBER}"
            }
        }
        
//          stage('Ansible Deployment') {
//             ansiblePlaybook credentialsId: 'ansibleCred', disableHostKeyChecking: true, installation: 'ansible', inventory: '/etc/ansible/hosts', playbook: 'demo-playbook.yml'
//          }
        
        
     }
}
catch(Exception err){
    echo "Exception occured..."
    currentBuild.result="FAILURE"
    //send an failure email notification to the user.
    mail bcc: '', body: 'Build Failed', cc: '', from: '', replyTo: '', subject: 'Your Build job status', to: 'dcourse07@gmail.com'
}
finally {
    (currentBuild.result!= "ABORTED") && node("master") {
        echo "finally gets executed and end an email notification for every build"
      mail bcc: '', body: 'Your Build is Successfull', cc: '', from: '', replyTo: '', subject: 'Your Build job status', to: 'dcourse07@gmail.com'
    }
   
    }
