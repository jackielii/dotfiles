# Keep large, regenerable development data on the external Stack volume.
# Go also has persistent paths in ~/.config/go/env for non-Fish processes.
if test -d /Volumes/Stack/go
    set -gx GOCACHE /Volumes/Stack/go/build
    set -gx GOMODCACHE /Volumes/Stack/go/mod
    set -gx GOTMPDIR /Volumes/Stack/go/tmp
end
if test -d /Volumes/Stack/huggingface
    set -gx HF_HOME /Volumes/Stack/huggingface
end
