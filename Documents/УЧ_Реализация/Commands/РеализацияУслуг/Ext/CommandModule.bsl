﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ВидОперации", "РеализацияУслуг");
	ТекФорма = ПолучитьФорму("Документ.УЧ_Реализация.Форма.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, "реал", ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	ТекФорма.АвтоЗаголовок = Ложь;
	ТекФорма.Заголовок = "Реализация услуг";
	ТекФорма.Открыть();
	
КонецПроцедуры
