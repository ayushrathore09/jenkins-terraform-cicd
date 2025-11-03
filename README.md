# jenkins-terraform-cicd
1. Always run terraform fmt locally before pushing the code to repo.
2. If you won't do that your pipeline will fail in tf fmt stage.
3. Added the parallel stages wherever possible to run independent stages to save time.
4. Added Retry and timeouts to prevent the build from hanging state and failed the stage:
   > either add at stage level which will cause your whole satge failed it timeout happens.
   > or add at step level for particular command to retry and timeout so that stage will not fail.

