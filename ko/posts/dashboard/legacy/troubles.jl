@error "이 파일은 include에 의해 열려서는 안 됩니다."

##############################################################
### ```markdown 문제가 있을 때 급하게 해결해주는 솔루션       ###
### write 함수는 매우 위험하므로 수동으로 주석을 해제하고 사용 ###
##############################################################
# dr = collect(eachrow(cached))[50]
for dr = eachrow(cached)
    en = read(dr.directory * "/index.en.md", String)
    if occursin("```markdown", en)
        en = replace(en, "```markdown" => "")
        if en[(end-2):end] == "```"
            en = strip(en, '`')
        end
        # write(dr.directory * "/index.en.md", en)
    end
    jp = read(dr.directory * "/index.jp.md", String)
    if occursin("```markdown", jp)
        jp = replace(jp, "```markdown" => "")
        if jp[(end-2):end] == "```"
            jp = strip(jp, '`')
        end
        # write(dr.directory * "/index.jp.md", jp)
    end
end