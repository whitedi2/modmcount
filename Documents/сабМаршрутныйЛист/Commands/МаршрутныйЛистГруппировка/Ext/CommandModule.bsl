﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//{{_КОНСТРУКТОР_ПЕЧАТИ(МаршрутныйЛистГруппировка)
	ТабДок = Новый ТабличныйДокумент;
	МаршрутныйЛистГруппировка(ТабДок, ПараметрКоманды);

	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.Показать();
	//}}
КонецПроцедуры

&НаСервере
Процедура МаршрутныйЛистГруппировка(ТабДок, ПараметрКоманды)
	Документы.сабМаршрутныйЛист.МаршрутныйЛистГруппировка(ТабДок, ПараметрКоманды);
КонецПроцедуры
