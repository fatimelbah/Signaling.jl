using Test, Signaling

@test hello("Julia") == "Hello, Julia"
@test domath(2.0) ≈ 7.0
