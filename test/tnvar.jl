using Test, SpecialFunctions, Statistics
import TruncatedNormal as TN

@test isnan(TN.tnvar(1, 0))
@test isnan(TN.tnvar(+Inf, 0))
@test isnan(TN.tnvar(0, -Inf))
@test isnan(TN.tnvar(NaN, NaN))
@test isnan(TN.tnvar(0, NaN))
@test isnan(TN.tnvar(NaN, 0))

@test TN.tnvar(-Inf, +Inf) == 1
@test TN.tnvar(+Inf, +Inf) == 0
@test TN.tnvar(-Inf, -Inf) == 0
@test TN.tnvar(0, +Inf) ≈ 1 - 2/π
@test TN.tnvar(-Inf, 0) ≈ 1 - 2/π

for x = -10:10
    @test TN.tnvar(x, +Inf) ≈ 1 + √(2/π) * x / erfcx(+x / √2) - 2/π / erfcx(+x / √2)^2
    @test TN.tnvar(-Inf, x) ≈ 1 - √(2/π) * x / erfcx(-x / √2) - 2/π / erfcx(-x / √2)^2
end

@test TN.tnvar(50, 70) ≈ 0.0003990431868038995479099272265360593305365


@test TN.tnvar(-Inf, Inf, 0, 1) == 1

for x = -10:10
    @test TN.tnvar(x, +Inf, 0, 1) ≈ TN.tnvar(x, +Inf)
    @test TN.tnvar(-Inf, x, 0, 1) ≈ TN.tnvar(-Inf, x)
end

@test TN.tnvar(50, 70, -2, 3) ≈ 0.029373438107168350377591231295634273607812172191712
@test TN.tnvar(-100.0, 0.0, 0.0, 2.0986317998643735) ≈ 1.6004193412141677189841357987638847137391508803335
@test TN.tnvar(0.0, 0.9, 0.0, 0.07132755843183151) ≈ 0.0018487407287725028827020557707636415445504260892486
@test TN.tnvar(-100.0, 100.0, 0.0, 17.185261847875548) ≈ 295.333163899557735486302841237124507431445
@test TN.tnvar(-100.0, 0.5, 0.0, 0.47383322897860064) ≈ 0.145041095812679283837328561547251019229612
@test TN.tnvar(-100.0, 100.0, 0.0, 17.185261847875548) ≈ 295.333163899557735486302841237124507431445
@test TN.tnvar(-10000, 10000, 0, 1) ≈ 1

# https://github.com/JuliaStats/Distributions.jl/issues/827
@test TN.tnvar(999000, 1e6) ≥ 0
@test TN.tnvar(0, 1000, 1000000, 1) ≥ 0

@test_broken TN.tnvar(1e6, Inf) ≈ 9.99999999994000000000050000000e-13
@test_broken TN.tnvar(999000, 1e6) ≈ 1.00200300399898194688784897455e-12
@test_broken TN.tnvar(0, 1000, 1000000, 1) ≈ 1.00200300399898194688784897455909681215272616880064850605775930845141e-12
