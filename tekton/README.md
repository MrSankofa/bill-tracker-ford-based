# Tekton (local Kubernetes) notes

## One-time setup
1. Ensure Docker Desktop Kubernetes is enabled.
2. Install Tekton Pipelines into the cluster (tekton-pipelines namespace).
3. Create the workspace PVC used by PipelineRuns (bill-tracker-workspace-pvc).
4. Deploy Postgres used by in-cluster integration tests:
   - kubectl apply -f tekton/resources/postgres.yaml

## Run backend tests in Tekton
1. Update the git revision in:
   - tekton/pipelineruns/backend-test.pipelinerun.yaml
2. Create a PipelineRun:
   - kubectl create -f tekton/pipelineruns/backend-test.pipelinerun.yaml
3. Watch:
   - kubectl get pipelinerun
   - kubectl get pods
4. Logs:
   - kubectl logs <gradle-test-pod> -c step-test

## Testcontainers strategy (Pattern A)
- Testcontainers tests are tagged: @Tag("testcontainers")
- Tekton excludes them using:
  - ./gradlew test -PexcludeTags=testcontainers
- Local + GitHub Actions can run them as needed.
