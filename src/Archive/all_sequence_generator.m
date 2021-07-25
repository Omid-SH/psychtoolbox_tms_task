% This code generates sequences 5 and 9 for all 16 subjects

id = input('Subject main index? ');

for j = 1:2
for k = 1:2
for l = 1:2
for p = 1:2
for d = 0:4
    for day = [5, 9]
        sequence_generator_function(id, j, k, l, p, d, day)
    end
end
end
end
end
end