# Gerekli kütüphaneler ile PSO ve GA sınıfları ekleniyor
from DE import DE
from TestFunc import TestFunc
import matplotlib.pyplot as plt

# DE Default parametreleri
de = DE(
    test_func=TestFunc().Sphere(),
    repeat=1,
    maxit=1000,
    npop=50,
    nvar=50,
    F=0.2,
    cp=0.2
)

pop, bestsol, bestcost, bests = de.run().values()
#result = de.run()
print(bests)

# Optimum DE sonuç grafiği çizdiriliyor
plt.semilogy(bestcost)
plt.xlim(0, 1000)
plt.xlabel('İterasyonlar')
plt.ylabel('Maliyet Fonksiyonu')
plt.title('Differential Evolution (DE)')
plt.grid(True)
plt.show()

# PSO için maliyet fonksiyonu GA olarak atanıyor
#PSO.CostFunction = gao
# GA parametre aralıkları tanımlanıyor. Sırasıyla:
# pc, gamma, mu, sigma, selectionType
# PSO parametreleri belirleniyor
# c1, c2 [0,5 - 2,5] w = [0,4 -0,9]

