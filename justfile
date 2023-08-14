version := `./fn.sh --version`

release:
    #!/usr/bin/env sh
    if git rev-parse --quiet --verify "refs/tags/{{version}}" &> /dev/null; then
        echo "Tag for {{version}} already exists."
        exit 1
    fi
    echo "Tag for {{version}} not created yet! Continuing..."
    git tag -a "{{version}}" "$(git rev-parse HEAD)" -m "$(git log -1 --format=%s)"
    git push origin "{{version}}"
    git push
vhs:
    cd ./docs && ./tape.sh