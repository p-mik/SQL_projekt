<h1>Reakce na zpětnou vazbu na projekt</h1>

<h2>Obecná vylepšení</h2>

<h3>ad ORDER BY</h3>
<p>Odeberu <code>ORDER BY</code> u tvorby primární tabulky. Děkuji za vysvětlení &ndash; chápu, že řadit data v tabulce není třeba. <code>ORDER BY</code> mi tam zůstal z nějaké mezifáze.</p>

<h3>ad SELECT * u tvorby tabulky secondary</h3>
<p>Zde jsem si nebyl jistý, jaké všechny sloupce budu pro tento a navazující projekt potřebovat. Z toho důvodu jsem chtěl z tabulky <code>countries</code> zařadit všechny sloupce, a těch je tam 30. Proto jsem využil symbol <code>*</code>. V budoucnu budu lépe přemýšlet nad tím, jaké sloupce zařadit a všechny je vypíšu.</p>

<h3>ad GROUP BY u agregačních funkcí</h3>
<p>Tady si budu muset projít všechny skripty, kde všude jsem toto &quot;nasekal&quot;. Děkuji za upozornění.</p>

<h3>Optimalizace a zrychlení běhu</h3>
<p>Bojoval jsem s CTE a nakonec se mi zdálo lepší řešit úkoly tak, jak jsem je odevzdal. Nicméně je mi jasné, že optimalizace je pro práci s daty esenciální a budu to mít nadále na paměti.</p>

<h2>Závěr k přepracování</h2>
<hr>

<h1>Odpovědi na výzkumné otázky</h1>

<h2>Q1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?</h2>
<p><strong>A1:</strong> Z dostupných dat vyplývá, že k meziročnímu poklesu mezd docházelo v období od roku 2006 do roku 2018 ve všech sledovaných odvětvích.</p>

<h2>Q2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?</h2>
<p><strong>A2:</strong> Za průměrnou mzdu v roce 2006 bylo možné si koupit 1 176 kilogramů chleba a 1 313 litrů mléka, zatímco v roce 2018 bylo možné za průměrnou mzdu nakoupit 1 233 kilogramů chleba a 1 508 litrů mléka.</p>

<h2>Q3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší procentuální meziroční nárůst)?</h2>
<p><strong>A3:</strong> V období od roku 2006 do roku 2018 došlo k nejmenšímu nárůstu ceny u potraviny &quot;Cukr krystalový&quot;. V uvedeném období došlo k poklesu průměrné ceny o 27,52 %.</p>

<h2>Q4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?</h2>
<p><strong>A4:</strong></p>
<ul>
  <li>V roce 2013 rostly ceny o 5,1 %, zatímco mzdy klesly o 5,95 %. Rozdíl mezi růstem cen a mezd byl tedy 11,05 %.</li>
  <li>V roce 2017 rostly ceny o 9,63 %, zatímco mzdy klesly o 1,26 %. Rozdíl mezi růstem cen a mezd byl tedy 10,89 %.</li>
  <li>V letech 2009 a 2018 byl naopak rozdíl mezi růstem cen a růstem mezd větší než 10 % ve prospěch růstu mezd.</li>
</ul>

<h2>Q5: Má výška HDP vliv na změny ve mzdách a cenách potravin?</h2>
<p><strong>A5:</strong> Zodpovězení této otázky je složitější. Pro doplnění odpovědi níže jsem do souborů přiložil dva grafy, které jsem na základě dat získaných pomocí dotazu SQL vytvořil v Excelu.</p>
<ol>
  <li>V období od roku 2007 do roku 2011 se dá říct, že změny mezd i cen věrněji kopírují vývoj HDP, přičemž vývoj cen kopíruje aktuální vývoj HDP a mzdy reagují na změnu HDP až následující rok. Dá se tedy říct, že zatímco růst cen předvídá či kopíruje růst HDP, mzdy na vývoj HDP až následně reagují.</li>
  <li>Od roku 2012 začíná vývoj mezd i cen více oscilovat, zatímco vývoj HDP je stabilnější. Stále však platí, že pokud zrychluje růst HDP, následující rok zrychluje také růst mezd. Naopak zpomalující růst HDP znamená zpomalení růstu mezd v následujícím roce. Vývoj cen ovšem s vývojem HDP v tomto období výrazně nekoreluje.</li>
</ol>
