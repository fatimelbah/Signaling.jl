push!(LOAD_PATH,"../src/")
using Documenter, Signaling

makedocs(modules = [Signaling], sitename = "Signaling.jl")

deploydocs(repo = "github.com/fatimelbah/Signaling.jl.git", devbranch = "main")
