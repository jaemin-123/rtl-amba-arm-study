module full_adder_g(
    input wire a, b, cin,
    output wire sum, cout
    );
    wire s1, c1, c2;
    
    xor (s1, a, b);
    and (c1, a, b);
    and G3 (c2, s1, cin);
    xor G4 (sum, s1, cin);
    or G5 (cout, c1, c2);
endmodule
