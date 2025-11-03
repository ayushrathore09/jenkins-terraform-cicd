# jenkins-terraform-cicd
1. Always run terraform fmt locally before pushing the code to repo.
2. If you won't do that your pipeline will fail in tf fmt stage.
3. Added the parallel stages wherever possible to run independent stages to save time.
4. Added timeouts to prevent the build from hanging state and failed the stage.

