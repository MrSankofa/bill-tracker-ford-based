#!/usr/bin/env bash
set -euo pipefail

BRANCH="$(git branch --show-current)"
REPO_URL="https://github.com/MrSankofa/bill-tracker-ford-based.git"

echo "Creating Tekton PipelineRun..."
echo "- Repo:   ${REPO_URL}"
echo "- Branch: ${BRANCH}"

RUN_NAME="$(
kubectl create -f - <<YAML | awk '{print $1}' | cut -d/ -f2
apiVersion: tekton.dev/v1
kind: PipelineRun
metadata:
  generateName: bill-tracker-backend-test-
spec:
  pipelineSpec:
    workspaces:
      - name: shared-workspace
    params:
      - name: git-url
        type: string
      - name: git-revision
        type: string
      - name: exclude-tags
        type: string
      - name: spring-profile
        type: string
    tasks:
      - name: clone
        taskRef:
          name: git-clone
        workspaces:
          - name: output
            workspace: shared-workspace
        params:
          - name: url
            value: \$(params.git-url)
          - name: revision
            value: \$(params.git-revision)
          - name: deleteExisting
            value: "true"
      - name: gradle-test
        runAfter: ["clone"]
        workspaces:
          - name: source
            workspace: shared-workspace
        taskSpec:
          params:
            - name: exclude-tags
              type: string
            - name: spring-profile
              type: string
          workspaces:
            - name: source
          steps:
            - name: test
              image: eclipse-temurin:21-jdk
              workingDir: \$(workspaces.source.path)/backend
              script: |
                #!/usr/bin/env bash
                set -euo pipefail
                chmod +x ./gradlew
                ./gradlew clean test \
                  -Dspring.profiles.active=\$(params.spring-profile) \
                  -PexcludeTags=\$(params.exclude-tags)
        params:
          - name: exclude-tags
            value: \$(params.exclude-tags)
          - name: spring-profile
            value: \$(params.spring-profile)
  params:
    - name: git-url
      value: ${REPO_URL}
    - name: git-revision
      value: ${BRANCH}
    - name: exclude-tags
      value: testcontainers
    - name: spring-profile
      value: test
  workspaces:
    - name: shared-workspace
      persistentVolumeClaim:
        claimName: bill-tracker-workspace-pvc
YAML
)"

echo
echo "Created: ${RUN_NAME}"
echo
echo "Watch:"
echo "  kubectl get pipelinerun ${RUN_NAME} -w"
echo
echo "Pods:"
echo "  kubectl get pods | grep ${RUN_NAME}"
echo
echo "Logs (gradle step):"
echo "  kubectl logs ${RUN_NAME}-gradle-test-pod -c step-test"
