release:
	git tag -a "$(./fn.sh --version)" "$(git rev-parse HEAD)" -m "$(git log -1 --format=%s)"
	git push origin "$(./fn.sh --version)"
	git push