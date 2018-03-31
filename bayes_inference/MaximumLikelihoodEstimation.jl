#!/usr/bin/env julia

include("Utils.jl")
include("DatasetMaker.jl")
include("Params.jl")

import DatasetMaker
import Utils
import Params


function main()

    # observed dataset
    xs, ys = DatasetMaker.make_observed_dataset(Params.RANGE, Params.N_SAMPLES)

    # extend xs(vector) to matrix
    xs_matrix = Utils.make_input_matrix(xs, Params.M)

    # solve a problem by maximum likelihood estimation
    w = inv(xs_matrix' * xs_matrix) * xs_matrix' * ys

    # calculate sigma
    sigma = sqrt(Utils.calculate_inv_lambda(w, xs, ys, Params.M))
    println("σ: $sigma")

    # predict curve for oxs
    oxs = linspace(0, Params.RANGE, Params.N_STEPS)
    oxs_matrix = Utils.make_input_matrix(oxs, Params.M)
    oys = oxs_matrix * w

    # make original curve
    oys_ground_truth = DatasetMaker.original_curve.(oxs)
   
    # draw curves
    Utils.draw_curves("Maximum Likelihood Estimation", oxs, oys, oys_ground_truth, xs, ys, sigma, "./mle.png")
end


main()