stage name: "Cool stage"
    sh 'whoami'
stage name: "Better stage"
    def current_stage = getCurrentStageName()
    echo "CONGRATULATIONS, you are on stage: $current_stage"
The question is how to implement getCurrentStageName()
