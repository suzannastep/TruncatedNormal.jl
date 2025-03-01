import Documenter
import Literate
import TruncatedNormal as TruncNorm

ENV["JULIA_DEBUG"] = "Documenter,Literate,TruncatedNormal"

#=
We place Literate.jl source .jl files and the generated .md files inside docs/src/literate.
=#
const literate_dir = joinpath(@__DIR__, "src/literate")

#=
Helper function to remove all "*.md" files from a directory.
=#
function clear_md_files(dir::String)
    for file in readdir(dir; join=true)
        if endswith(file, ".md")
            rm(file)
        end
    end
end

#=
Remove previously Literate.jl generated files. This removes all "*.md" files inside
`literate_dir`. This is a precaution: if we build docs locally and something fails,
and then change the name of a source file (".jl"), we will be left with a lingering
".md" file which will be included in the docs build. The following line makes sure
that doesn't happen.
=#
clear_md_files(literate_dir)

#=
Run Literate.jl on the .jl source files within docs/literate.
This creates the markdown .md files inside docs/src/literate,
with the same name but with the extension changes (.jl -> .md).
=#
for file in readdir(literate_dir; join=true)
    if endswith(file, ".jl")
        Literate.markdown(file, literate_dir)
    end
end

#=
Build docs.
=#
Documenter.makedocs(
    modules = [TruncNorm],
    sitename = "TruncatedNormal.jl",
    pages = [
        "Home" => "index.md",
        "Reference" => "reference.md",
    ],
    strict = true
)

#=
After the docs have been compiled, we can remove the *.md files generated by Literate.
=#
clear_md_files(literate_dir)

#=
Deploy docs to Github pages.
=#
Documenter.deploydocs(
    repo = "github.com/cossio/TruncatedNormal.jl.git",
    devbranch = "master"
)
