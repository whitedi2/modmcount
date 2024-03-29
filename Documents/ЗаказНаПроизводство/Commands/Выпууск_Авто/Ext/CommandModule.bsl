﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	РеквыЗаказа = БюджетныйНаСервере.ВернутьРеквизиты(ПараметрКоманды, "Организация, ВидОперации");
	
	Если ЗначениеЗаполнено(РеквыЗаказа.Организация) Тогда
		ПараметрыФормы = Новый Структура("Основание", ПараметрКоманды);
		Если РеквыЗаказа.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацииВыпускаПродукции.Производство") Тогда
			ОткрытьФорму("Документ.ОтчетПроизводстваЗаСмену.Форма.ФормаВыпускПродукции", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
		Иначе	
			ОткрытьФорму("Документ.ОтчетПроизводстваЗаСмену.Форма.ФормаДокументаОтчетПроизводстваЗаСмену", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
		КонецЕсли;
	Иначе	
		ПараметрыФормы = Новый Структура("Основание", ПараметрКоманды);
		ОткрытьФорму("Документ.УЧ_ВыпускПродукции.ФормаОбъекта", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	КонецЕсли;	
	
КонецПроцедуры

Процедура ЗаполнитьНаСервере(ЭтотОбъект, ДанныеЗаполнения)

Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,,"Дата, Номер, Проведен");
		ЭтотОбъект.ВидОперации = Перечисления.ВидыОперацийРозничнаяПродажа.Продажа;
		ЭтотОбъект.Заказ = ДанныеЗаполнения;
		ЭтотОбъект.СуммаВключаетНДС = Истина;
		ЭтотОбъект.ДокументБезНДС = Ложь;
		ЭтотОбъект.Дата = ДанныеЗаполнения.ДатаПоступления;
		//ЭтотОбъект.СчетКасса = ПланыСчетов.Хозрасчетный.НайтиПоКоду("50.01");
		//ЭтотОбъект.СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоНаименованию("Розничная выручка", Истина);
		//ЭтотОбъект.ДоговорКонтрагента = ДанныеЗаполнения.Договор;
		ЭтотОбъект.ТипЦен = ДанныеЗаполнения.Договор.ТипЦен;
		Для каждого ТекСтрока Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
			НоваяСтрока = ЭтотОбъект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			НоваяСтрока.СтавкаНДС = сабОбщегоНазначенияБУХПовтИсп.СоотвСтавокНДСУУБУХ().Получить(ТекСтрока.СтавкаНДС);
		КонецЦикла;
		
		НовОбъект = Документы.РозничнаяПродажа.СоздатьДокумент();
		ЗаполнитьЗначенияСвойств(НовОбъект, ДанныеЗаполнения,,"Дата, Номер");
		НовОбъект.ВидОперации = Перечисления.ВидыОперацийРозничнаяПродажа.Продажа;
		НовОбъект.Заказ = ДанныеЗаполнения;
		НовОбъект.СуммаВключаетНДС = Истина;
		НовОбъект.ДокументБезНДС = Ложь;
		Для каждого ТекСтрока Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
			НоваяСтрока = НовОбъект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			НоваяСтрока.СтавкаНДС = сабОбщегоНазначенияБУХПовтИсп.СоотвСтавокНДСУУБУХ().Получить(ТекСтрока.СтавкаНДС);
		КонецЦикла;
		
		ЗаполнениеДокументов.Заполнить(НовОбъект, ДанныеЗаполнения);
		
		ЭтотОбъект.Товары.Очистить();
		Для каждого ТекСтрока Из НовОбъект.Товары Цикл
			НоваяСтрока = ЭтотОбъект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры
