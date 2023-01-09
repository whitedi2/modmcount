﻿
&После("ПередЗаписью")
Процедура УУ_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если Модифицированность() Тогда
		сабОбщегоНазначенияБУХ.УстановитьМодифицированностьБУДокумента(ЭтотОбъект, Ссылка);	
	КонецЕсли;
КонецПроцедуры

&После("ОбработкаПроведения")
Процедура УУ_ОбработкаПроведения(Отказ, РежимПроведения)
	
	//меняем статус заказа
	Если НЕ ДополнительныеСвойства.Свойство("НеИзменятьСтатусЗаказа") И ЗначениеЗаполнено(Заказ) И ТипЗнч(Заказ) = Тип("ДокументСсылка.ЗаказНаПеремещение") И Не Заказ.Статус = Перечисления.СтатусыЗаказовПоставщикам.Закрыт Тогда		
		ЗаказОб = Заказ.ПолучитьОбъект();
		ЗаказОб.Статус = Перечисления.СтатусыЗаказовПоставщикам.Закрыт;
		Если ЗаказОб.Проведен Тогда
			ЗаказОб.Записать(РежимЗаписиДокумента.Проведение);
		Иначе	
			ЗаказОб.Записать(РежимЗаписиДокумента.Запись);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&После("ОбработкаЗаполнения")
Процедура УУ_ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказНаПеремещение") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,,"Дата, Номер, Проведен");
		ЭтотОбъект.ВидОперации =  Перечисления.ВидыОперацийПеремещениеТоваров.ПередачаМеждуСкладами;
		ЭтотОбъект.Заказ = ДанныеЗаполнения;
		ЭтотОбъект.СкладОтправитель = ДанныеЗаполнения.Склад;
		//ЭтотОбъект.ДокументБезНДС = Ложь;
		//ЭтотОбъект.ДоговорКонтрагента = ДанныеЗаполнения.Договор;
		//ЭтотОбъект.ТипЦен = ЭтотОбъект.ДоговорКонтрагента.ТипЦен;
		ЭтотОбъект.Дата = ДанныеЗаполнения.ДатаПоступления;
		//ЭтотОбъект.ЭтоУниверсальныйДокумент = Истина;
		//ЭтотОбъект.ВалютаДокумента = ДанныеЗаполнения.Валюта;
		//Если Не ЗначениеЗаполнено(ЭтотОбъект.ВалютаДокумента) Тогда
		//	ЭтотОбъект.ВалютаДокумента = УЧ_Сервер.НациональнаяВалюта();		
		//КонецЕсли;
		Для каждого ТекСтрока Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
			НоваяСтрока = ЭтотОбъект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			//НоваяСтрока.СтавкаНДС = сабОбщегоНазначенияБУХПовтИсп.СоотвСтавокНДСУУБУХ().Получить(ТекСтрока.СтавкаНДС);
			//Если Не ЗначениеЗаполнено(ЭтотОбъект.Склад) Тогда
			//	ЭтотОбъект.Склад = ТекСтрока.Склад;	
			//КонецЕсли;
		КонецЦикла;
		
		НовОбъект = Документы.ПеремещениеТоваров.СоздатьДокумент();
		ЗаполнитьЗначенияСвойств(НовОбъект, ДанныеЗаполнения,,"Дата, Номер");
		НовОбъект.ВидОперации = Перечисления.ВидыЗаказовНаПеремещение.ПеремещениеМеждуСкладами;
		НовОбъект.Заказ = ДанныеЗаполнения;
		//НовОбъект.СуммаВключаетНДС = Истина;
		//НовОбъект.ДокументБезНДС = Ложь;
		Для каждого ТекСтрока Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
			НоваяСтрока = НовОбъект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			//НоваяСтрока.СтавкаНДС = сабОбщегоНазначенияБУХПовтИсп.СоотвСтавокНДСУУБУХ().Получить(ТекСтрока.СтавкаНДС);
		КонецЦикла;
		
		ЗаполнениеДокументов.Заполнить(НовОбъект, ДанныеЗаполнения, Истина);
		
		ЭтотОбъект.Товары.Очистить();
		
		МассивНоменклатуры = Новый Массив;
		
		Для каждого ТекСтрока Из НовОбъект.Товары Цикл
			НоваяСтрока = ЭтотОбъект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			МассивНоменклатуры.Добавить(НоваяСтрока.Номенклатура);
		КонецЦикла;
			
	КонецЕсли;

КонецПроцедуры
