Problem.find_or_create_by(name: "Hydrogen Atom Radial Wavefunction n=2 l=1 m=0") do |p|
  p.domain = "wavefunction"
  p.tier = 2
  p.problem_statement = <<~STATEMENT
    Compute the radial wavefunction R_21(r) for the hydrogen atom with quantum 
    numbers n=2, l=1. Evaluate R_21(r) at r = a_0, 2*a_0, 4*a_0, and 6*a_0 
    where a_0 is the Bohr radius (5.29177210903e-11 m). 
    Also verify normalization: the integral of |R_21(r)|^2 * r^2 dr 
    from 0 to infinity must equal 1.0 within tolerance 1e-6.

    The exact analytical form is:
    R_21(r) = (1 / sqrt(24)) * (1/a_0)^(3/2) * (r/a_0) * exp(-r / (2*a_0))
  STATEMENT
  p.input_parameters = JSON.generate({
    n: 2,
    l: 1,
    m: 0,
    a_0: 5.29177210903e-11,
    r_values: [1.0, 2.0, 4.0, 6.0],
    r_units: "multiples of a_0",
    normalization_tolerance: 1.0e-6
  })
  p.expected_output_description = <<~OUTPUT
    Four values of R_21(r) evaluated at r = 1*a_0, 2*a_0, 4*a_0, 6*a_0.
    Normalization integral equal to 1.0 within 1e-6.
    Units of R_21: m^(-3/2).
  OUTPUT
  p.source_reference = "Griffiths, Introduction to Quantum Mechanics, 3rd ed., Table 4.7"
end
