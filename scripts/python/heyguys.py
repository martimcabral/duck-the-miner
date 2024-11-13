import random

consoantes = {'b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'y', 'z'}
vogais = {'a', 'e', 'i', 'o', 'u'}
# AsteroidCamp = {"Delta", "Gamma", "Omega", "Lambda", "Sigma", "Yotta"}

def CreateAsteroid():
    # local = random.choice(list(AsteroidCamp))
    consoante1 = random.choice(list(consoantes))
    consoante2 = random.choice(list(consoantes))
    consoante3 = random.choice(list(consoantes))
    consoante4 = random.choice(list(consoantes))
    vogal1 = random.choice(list(vogais))
    vogal2 = random.choice(list(vogais))
    vogal3 = random.choice(list(vogais))
    vogal4 = random.choice(list(vogais))
    vogal5 = random.choice(list(vogais))
    vogal6 = random.choice(list(vogais))
    
    variante = random.randint(1, 9)
    
    match variante:
        case 1:
            novo_asteroide = consoante1.upper() + vogal1 + vogal2 + consoante2 + vogal3
        case 2:
            novo_asteroide = consoante1.upper() + vogal1 + vogal2 + consoante2 + vogal3 + consoante3 + vogal4
        case 3:
            novo_asteroide = consoante1.upper() + vogal1 + consoante2
        case 4:
            novo_asteroide = consoante1.upper() + consoante2 + vogal1 + consoante3 + vogal2+ vogal3
        case 5:
            novo_asteroide = vogal1.upper() + consoante1 + consoante2 + vogal2 + "-" + consoante3.upper() + vogal3 + consoante4 + vogal4
        case 6:
            novo_asteroide = vogal1.upper() + consoante1 + consoante2 + vogal3 + vogal3
        case 7:
            novo_asteroide = consoante1.upper() + vogal1 + vogal2 + consoante2 + vogal3 + vogal4 + consoante3 + consoante4 + vogal5
        case 8:
            novo_asteroide = consoante1.upper() + vogal1 + consoante2 + vogal2 + consoante3 + vogal3 + consoante3 + vogal4 + vogal5 + consoante4 + vogal6
        case 9:
            novo_asteroide = consoante1.upper() + vogal1 + consoante2 + consoante3 + vogal2 + consoante4
    return novo_asteroide

for i in range(200000):
    print(CreateAsteroid())