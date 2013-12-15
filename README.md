SOA Projekt
===========

Projekt na predmet Architektúry orientované na služby, princípy a technológie.

Tento projet zahŕňa prácu s Web services. 

V princípe ide o kompozíciu servisov, ktorá predstabuje správu autoservisu. 

Obsahuje 4 zlužby a 1 orchestráciu.

Services
--------

### Cars

Service ktorý poskutuje zoznam áut. Do zoznamu sa dá auto pridať a z neho získať. 

_Táto služba poskytuje metódu, ktorá dostáva ako parameter inštanciu triedy Car_

### Boxes

Boxes poskytuje "voľnosť" daných boxov. Na otázku, či je box volný odpovie booleanom.

_Táto služba je urobená metódou WSDL first._

### Components

Poskytuje zoznam komponentov a ich inventár. Komponenty sa dajú pridávať (registrovať), pridávať do inventára a zisťovať, či ich je v inventári dostatok.

_Táto služba poskytuje metódu, ktorá dostáva ako parameter inštanciu triedy Component_

### Workers

Poskytuje API, ktoré vraví, či má pracovník s daným menom v danom čase voľno. Tiež umožnuje pracovníkom nastavovať kedy pracujú.

Implementácia nezohľadňuje čas, iba pozerá, či je pracovník voľný.

### Orch

Orchestrácia týchto Web service-ov je veľmi jednoduchá, poskytuje jedinú metódu, ktorá overí, či v sa dá opraviť dané auto, v danom boxe daným človekom a použíť daný komponent. 

To znamená, že sa ostatných služieb opýta na existenciu a voľnosť daných zdrojov a následne odpovie booleanom.

Ako testovať
------------

  1. V prvom rade treba na všetkých projektoch vykonať získanie závyslostí. 
  2. Následne v projekte boxes vykonať maven clean ( ak nevygeneruje zdroje, treba ešte vykonať maven generate-sources )
  3. Následne by malo byť všetko pripravené, a môžeme spúšťať služby. 
    - Spustíme cars/src/main/java/com/example/carservice/server/Server.java
    - Spustíme boxes/src/main/java/com/example/boxservice/server/Server.java
    - Spustíme components/src/main/java/com/example/componentservice/server/Server.java
    - Spustíme workers/src/main/java/com/example/workerservice/server/Server.java
    - A na záver spustíme orch/src/main/java/com/example/orchservice/server/Server.java
  4. Teraz máme spustené všetky servisy, môžeme spustiť klienta 
    - Spustíme orch/src/main/java/com/example/orchservice/client/Client.java

V projekte orch sú vygenerované triedy ktoré používame pomocou wsimport z wsdl služieb, aby sme ich nemuseli includovať. 
