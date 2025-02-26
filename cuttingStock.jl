function main()
    c = 0
    while c <= 0
        print("Digite o comprimento da barra original (> 0): ")
        c = parse(Int, readline())
    end

    println("")
    print("Quantas peças >diferentes< tem o problema: ")
    n = parse(Int, readline())
    println("")
    tamanhos = Int[]
    demandas = Int[]

    while length(demandas) != n || length(tamanhos) != n || maximum(tamanhos) > c || maximum(tamanhos) <= 0
        print("Insira o tamanho das peças desejadas (ex: 2 4 3 1...): ")
        tamanhos = [parse(Int, x) for x in split(readline())]
        print("Insira a demanda de cada peça (ex: 30 12 1 9...): ")
        demandas = [parse(Int, x) for x in split(readline())]
    end
    println("")
    ordem = sortperm(tamanhos, rev = true)
    tamanhos = tamanhos[ordem]
    demandas = demandas[ordem]

    resultado = problemaCorte(tamanhos, demandas, c)
    println("Número mínimo de barras necessárias: ", resultado)
end

function problemaCorte(tamanhos, demandas, c)
    t = time()
    #padroes = Dict{Vector{Int}, Int}()
    totalUsado = 0
    n = length(tamanhos)
    while maximum(demandas) > 0
        solOtima = zeros(Int, c+1)
        pecasEscolhidas = [Vector{Int}() for _ in 1:c+1]
        usos = [zeros(Int, n) for _ in 1:c+1]
        for t in 2:c+1
            for i in 1:n
                if tamanhos[i] <= t-1
                    valor = solOtima[t - tamanhos[i]] + tamanhos[i]
                    if solOtima[t] < valor
                        quantas = count(x->x == tamanhos[i], pecasEscolhidas[t-tamanhos[i]])
                        if quantas + 1 <= demandas[i]
                            solOtima[t] = valor
                            pecasEscolhidas[t] = deepcopy(pecasEscolhidas[t - tamanhos[i]])
                            usos[t][i]+= quantas + 1
                            push!(pecasEscolhidas[t], tamanhos[i]) 
                        end
                    end
                end
            end
        end
        indice = argmax(solOtima)[1]
        podeCortar = true
        for j in 1:n
            if usos[indice][j] > demandas[j]
                podeCortar = false
            end
        end
        if podeCortar
            #if haskey(padroes, pecasEscolhidas[indice])
            #    padroes[pecasEscolhidas[indice]] += 1
            #else
            #    padroes[pecasEscolhidas[indice]] = 1
            #end
            for j in 1:n
                for peca in pecasEscolhidas[indice]
                    if tamanhos[j] == peca && demandas[j] > 0
                        demandas[j] -= 1
                    end
                end
            end
            totalUsado += 1
        end
    end
    #println(padroes)
    println("Tempo necessário: $(time() - t)s")
    return totalUsado
end

main()