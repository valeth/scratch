#!/usr/bin/env ruby

# m = mass (kg)
# h = height (m)
# BMI = m / h


def classification(bmi)
    case
    when bmi >= 40.00               then 'Morbid Obesity'
    when bmi.between?(35.00, 40.00) then 'Obesity (Class 2)'
    when bmi.between?(30.00, 35.00) then 'Obesity (Class 1)'
    when bmi.between?(25.00, 30.00) then 'Overweight'
    when bmi.between?(18.50, 25.00) then 'Normal Weight'
    when bmi <= 19.50               then 'Underweight'
    else 'Unknown'
    end
end


abort('requires mass and height parameters') if ARGV.size < 2
weight = ARGV[0].to_f
height = ARGV[1].to_f
bmi = (weight / (height * height))

puts "You are #{weight}kg heavy and #{height}m tall."
puts "Your BMI is #{bmi}, classification #{classification(bmi)}"
