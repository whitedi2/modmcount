﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	ПараметрыФормы = Новый Структура("", );
	ОткрытьФорму("Документ.УЧ_ВводОстатков.Форма.ФормаВыбораСчетов", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	//ОткрытьФормуМодально("Документ.УЧ_ВводОстатков.Форма.ФормаВыбораСчетов");
КонецПроцедуры
