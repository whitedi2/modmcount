﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	РеквыЗаказа = БюджетныйНаСервере.ВернутьРеквизиты(ПараметрКоманды, "Организация, ПродажаВРозницу, БезвозмезднаяПередача");
	
	Если ЗначениеЗаполнено(РеквыЗаказа.Организация) Тогда
		Если РеквыЗаказа.БезвозмезднаяПередача Тогда
			ПараметрыФормы = Новый Структура("Основание", ПараметрКоманды);
			ОткрытьФорму("Документ.ПередачаТоваров.Форма.ФормаДокументаБезвозмезднаяПередача", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
		ИначеЕсли РеквыЗаказа.ПродажаВРозницу Тогда
			ПараметрыФормы = Новый Структура("Основание", ПараметрКоманды);
			
			ТекФормаБП = ПолучитьФорму("Документ.РозничнаяПродажа.Форма.ФормаДокументаОбщая");
			
			ДанныеФормы = ТекФормаБП.Объект;
			ЗаполнитьНаСервере(ДанныеФормы, ПараметрКоманды);
			КопироватьДанныеФормы(ДанныеФормы, ТекФормаБП.Объект);
			
			Объект = ДанныеФормы;
			СтруктураНадписи = Новый Структура(
			"СуммаВключаетНДС, ДокументБезНДС, ВалютаРегламентированногоУчета",
			Объект.СуммаВключаетНДС,
			Объект.ДокументБезНДС,
			ТекФормаБП.ВалютаРегламентированногоУчета);
			Если ТекФормаБП.ИспользоватьТипыЦенНоменклатуры Тогда
				СтруктураНадписи.Вставить("ТипЦен", Объект.ТипЦен);
			КонецЕсли;
			ТекФормаБП.ЦеныИВалюта = ОбщегоНазначенияБПКлиентСервер.СформироватьНадписьЦеныИВалюта(СтруктураНадписи);
			
			ТекФормаБП.ОбновитьОтображениеДанных();
			ТекФормаБП.Открыть();
			
		Иначе
			ПараметрыФормы = Новый Структура("Основание", ПараметрКоманды);
			ОткрытьФорму("Документ.РеализацияТоваровУслуг.Форма.ФормаДокументаОбщая", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
		КонецЕсли;
	Иначе	
		ПараметрыФормы = Новый Структура("Основание", ПараметрКоманды);
		ОткрытьФорму("Документ.УЧ_Реализация.ФормаОбъекта", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	КонецЕсли;	

КонецПроцедуры

Процедура ЗаполнитьНаСервере(ЭтотОбъект, ДанныеЗаполнения)

	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
		Отказ = сабОперОбщегоНазначения.ПроверкаСозданияНаОснованииНаСервере(ДанныеЗаполнения, "", Истина, ТипЗнч(ЭтотОбъект.Ссылка));
		Если Отказ.Признак = "##УжеСоздан" Тогда
			ВызватьИсключение "На основании заказа уже введен документ " + Отказ.Ссылка;
		ИначеЕсли Отказ.Признак = "##НеПроведен" Тогда
			ВызватьИсключение "Документ заказ клиента не проведен. Ввод на основании не возможен.";
		КонецЕсли;
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
