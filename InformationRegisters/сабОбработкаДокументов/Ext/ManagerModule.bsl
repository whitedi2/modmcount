﻿Функция ПолучитьНеобработанныеДокументы(ВыбратьПервые = Неопределено) Экспорт
	
	ДатаВводаОстатков = Дата('00010101');
	ТекСтрока = Справочники.сабМониторВнедрения.НайтиПоНаименованию("Дата остатков", Истина);
	Если ЗначениеЗаполнено(ТекСтрока) Тогда
		ДатаВводаОстатков = ТекСтрока.Значение;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	сабСоответствиеТиповДокументов.ТипДокументаУУ КАК ТипДокументаУУ,
	|	сабСоответствиеТиповДокументов.ТипДокументаБУ КАК ТипДокументаБУ
	|ИЗ
	|	РегистрСведений.сабСоответствиеТиповДокументов КАК сабСоответствиеТиповДокументов
	|ГДЕ
	|	сабСоответствиеТиповДокументов.ТипДокументаУУ = &ТипДокументаУУ";
	
	Запрос.УстановитьПараметр("ТипДокументаУУ", "Исключено");
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выгрузить().ВыгрузитьКолонку("ТипДокументаБУ");
	
	МассивИсклТипов = Новый Массив;
	Для каждого ТекСтрока Из Выборка Цикл
		МассивИсклТипов.Добавить(Тип("ДокументСсылка." + Строка(ТекСтрока)));	
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаНеобработанных(ВыбратьПервые);
	Запрос.УстановитьПараметр("Дата", ДатаВводаОстатков);
	Запрос.УстановитьПараметр("МассивИсклТипов", МассивИсклТипов);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выгрузить();
	МассивСтруктур = Новый Массив;
	Для каждого ТекСтрока Из Выборка Цикл
		МассивСтруктур.Добавить(Новый Структура("Ссылка", ТекСтрока.Ссылка)); 
	КонецЦикла; 
	
	Возврат МассивСтруктур;
	
КонецФункции // ()

Функция ПолучитьНеобработанныеДокументыРозница(ВыбратьПервые = Неопределено) Экспорт
	
	ДатаВводаОстатков = Дата('00010101');
	ТекСтрока = Справочники.сабМониторВнедрения.НайтиПоНаименованию("Дата остатков", Истина);
	Если ЗначениеЗаполнено(ТекСтрока) Тогда
		ДатаВводаОстатков = ТекСтрока.Значение;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	сабСоответствиеТиповДокументов.ТипДокументаУУ КАК ТипДокументаУУ,
	|	сабСоответствиеТиповДокументов.ТипДокументаБУ КАК ТипДокументаБУ
	|ИЗ
	|	РегистрСведений.сабСоответствиеТиповДокументов КАК сабСоответствиеТиповДокументов
	|ГДЕ
	|	сабСоответствиеТиповДокументов.ТипДокументаУУ = &ТипДокументаУУ";
	
	Запрос.УстановитьПараметр("ТипДокументаУУ", "Исключено");
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выгрузить().ВыгрузитьКолонку("ТипДокументаБУ");
	
	МассивИсклТипов = Новый Массив;
	Для каждого ТекСтрока Из Выборка Цикл
		МассивИсклТипов.Добавить(Тип("ДокументСсылка." + Строка(ТекСтрока)));	
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаНеобработанныхРозница(ВыбратьПервые);
	Запрос.УстановитьПараметр("Дата", ДатаВводаОстатков);
	Запрос.УстановитьПараметр("МассивИсклТипов", МассивИсклТипов);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выгрузить();
	МассивСтруктур = Новый Массив;
	Для каждого ТекСтрока Из Выборка Цикл
		МассивСтруктур.Добавить(Новый Структура("Ссылка", ТекСтрока.Ссылка)); 
	КонецЦикла;
	
	Возврат МассивСтруктур;
	
КонецФункции // ()

Процедура ОбработатьДокументыБУНаСервере(ТекДокументСтруктура, СтруктураВозврата = Неопределено) Экспорт
	
	//НачатьТранзакцию();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	сабСоответствиеТиповДокументов.ТипДокументаУУ КАК ТипДокументаУУ,
	|	сабСоответствиеТиповДокументов.ТипДокументаБУ КАК ТипДокументаБУ
	|ИЗ
	|	РегистрСведений.сабСоответствиеТиповДокументов КАК сабСоответствиеТиповДокументов
	|ГДЕ
	|	сабСоответствиеТиповДокументов.ТипДокументаБУ = &ТипДокументаБУ";
	
	Запрос.УстановитьПараметр("ТипДокументаБУ", ТекДокументСтруктура.Ссылка.Метаданные().Имя);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ЕстьСоответствие = Ложь;
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ТипДокументаБУ = "РеализацияТоваровУслуг" И Выборка.ТипДокументаУУ = "УЧ_Реализация" Тогда
			
			Если СтруктураВозврата = Неопределено Тогда
				НоваяОперация = Документы.УЧ_Реализация.СоздатьДокумент();
				НоваяОперация.Заполнить(ТекДокументСтруктура.Ссылка);
				НоваяОперация.ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
				НоваяОперация.ДополнительныеСвойства.Вставить("ДокументБУ", ТекДокументСтруктура.Ссылка);
				НоваяОперация.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				СтруктураВозврата.Вставить("ИмяФормы", "УЧ_Реализация");	
			КонецЕсли;
			
			ЕстьСоответствие = Истина;
		КонецЕсли;
		
		Если Выборка.ТипДокументаБУ = "ПоступлениеТоваровУслуг" И Выборка.ТипДокументаУУ = "УЧ_ПоступлениеТоваров" Тогда
			
			Если СтруктураВозврата = Неопределено Тогда
				НоваяОперация = Документы.УЧ_ПоступлениеТоваров.СоздатьДокумент();
				НоваяОперация.Заполнить(ТекДокументСтруктура.Ссылка);
				НоваяОперация.ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
				НоваяОперация.ДополнительныеСвойства.Вставить("ДокументБУ", ТекДокументСтруктура.Ссылка);
				НоваяОперация.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				СтруктураВозврата.Вставить("ИмяФормы", "УЧ_ПоступлениеТоваров");	
			КонецЕсли;
			
			ЕстьСоответствие = Истина;
		КонецЕсли;
		
		Если Выборка.ТипДокументаБУ = "СписаниеСРасчетногоСчета"  И Выборка.ТипДокументаУУ = "УЧ_ДвижениеДС" Тогда
			
			Если ТипЗнч(ТекДокументСтруктура.Ссылка.ДокументОснование) = Тип("ДокументСсылка.ПлатежноеПоручение") И ЗначениеЗаполнено(ТекДокументСтруктура.Ссылка.ДокументОснование)
				И ЗначениеЗаполнено(ТекДокументСтруктура.Ссылка.ДокументОснование.Заявка) Тогда
				
				Если СтруктураВозврата = Неопределено Тогда
					НоваяОперация = Документы.УЧ_ДвижениеДС.СоздатьДокумент();
					НоваяОперация.Заполнить(ТекДокументСтруктура.Ссылка.ДокументОснование);
					НоваяОперация.ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
					НоваяОперация.ДополнительныеСвойства.Вставить("ДокументБУ", ТекДокументСтруктура.Ссылка);
					НоваяОперация.Записать(РежимЗаписиДокумента.Проведение);
				Иначе
					СтруктураВозврата.Вставить("ИмяФормы", "УЧ_ДвижениеДС");
					СтруктураВозврата.Вставить("Ссылка", ТекДокументСтруктура.Ссылка.ДокументОснование);
				КонецЕсли; 
				
			Иначе
				
				Если СтруктураВозврата = Неопределено Тогда
					НоваяОперация = Документы.УЧ_ДвижениеДС.СоздатьДокумент();
					НоваяОперация.Заполнить(ТекДокументСтруктура.Ссылка);
					НоваяОперация.ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
					НоваяОперация.ДополнительныеСвойства.Вставить("ДокументБУ", ТекДокументСтруктура.Ссылка);
					НоваяОперация.Записать(РежимЗаписиДокумента.Проведение);
				Иначе
					СтруктураВозврата.Вставить("ИмяФормы", "УЧ_ДвижениеДС");	
				КонецЕсли;
				
			КонецЕсли; 
			
			ЕстьСоответствие = Истина;
		КонецЕсли;
		
		Если Выборка.ТипДокументаБУ = "ПоступлениеНаРасчетныйСчет" И Выборка.ТипДокументаУУ = "УЧ_ДвижениеДС" Тогда
			
			Если СтруктураВозврата = Неопределено Тогда
				НоваяОперация = Документы.УЧ_ДвижениеДС.СоздатьДокумент();
				НоваяОперация.Заполнить(ТекДокументСтруктура.Ссылка);
				НоваяОперация.ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
				НоваяОперация.ДополнительныеСвойства.Вставить("ДокументБУ", ТекДокументСтруктура.Ссылка);
				НоваяОперация.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				СтруктураВозврата.Вставить("ИмяФормы", "УЧ_ДвижениеДС");	
			КонецЕсли;
			
			ЕстьСоответствие = Истина;
		КонецЕсли;
		
		Если Выборка.ТипДокументаБУ = "РасходныйКассовыйОрдер" И Выборка.ТипДокументаУУ = "УЧ_ДвижениеДС" Тогда
			
			Если СтруктураВозврата = Неопределено Тогда
				НоваяОперация = Документы.УЧ_ДвижениеДС.СоздатьДокумент();
				НоваяОперация.Заполнить(ТекДокументСтруктура.Ссылка);
				НоваяОперация.ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
				НоваяОперация.ДополнительныеСвойства.Вставить("ДокументБУ", ТекДокументСтруктура.Ссылка);
				НоваяОперация.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				СтруктураВозврата.Вставить("ИмяФормы", "УЧ_ДвижениеДС");	
			КонецЕсли;
			
			ЕстьСоответствие = Истина;
		КонецЕсли;
		
		Если Выборка.ТипДокументаБУ = "ПриходныйКассовыйОрдер" И Выборка.ТипДокументаУУ = "УЧ_ДвижениеДС" Тогда
			
			Если СтруктураВозврата = Неопределено Тогда
				НоваяОперация = Документы.УЧ_ДвижениеДС.СоздатьДокумент();
				НоваяОперация.Заполнить(ТекДокументСтруктура.Ссылка);
				НоваяОперация.ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
				НоваяОперация.ДополнительныеСвойства.Вставить("ДокументБУ", ТекДокументСтруктура.Ссылка);
				НоваяОперация.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				СтруктураВозврата.Вставить("ИмяФормы", "УЧ_ДвижениеДС");	
			КонецЕсли;
			
			ЕстьСоответствие = Истина;
		КонецЕсли;
		
		Если Выборка.ТипДокументаБУ = "СписаниеТоваров" И Выборка.ТипДокументаУУ = "УЧ_СписаниеТоваров" Тогда
			
			Если СтруктураВозврата = Неопределено Тогда
				НоваяОперация = Документы.УЧ_СписаниеТоваров.СоздатьДокумент();
				НоваяОперация.Заполнить(ТекДокументСтруктура.Ссылка);
				НоваяОперация.ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
				НоваяОперация.ДополнительныеСвойства.Вставить("ДокументБУ", ТекДокументСтруктура.Ссылка);
				НоваяОперация.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				СтруктураВозврата.Вставить("ИмяФормы", "УЧ_СписаниеТоваров");	
			КонецЕсли;
			
			ЕстьСоответствие = Истина;
		КонецЕсли;
		
		Если Выборка.ТипДокументаБУ = "ОприходованиеТоваров" И Выборка.ТипДокументаУУ = "УЧ_ОприходованиеТоваров" Тогда
			
			Если СтруктураВозврата = Неопределено Тогда
				НоваяОперация = Документы.УЧ_ОприходованиеТоваров.СоздатьДокумент();
				НоваяОперация.Заполнить(ТекДокументСтруктура.Ссылка);
				НоваяОперация.ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
				НоваяОперация.ДополнительныеСвойства.Вставить("ДокументБУ", ТекДокументСтруктура.Ссылка);
				НоваяОперация.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				СтруктураВозврата.Вставить("ИмяФормы", "УЧ_ОприходованиеТоваров");	
			КонецЕсли;
			
			ЕстьСоответствие = Истина;
		КонецЕсли;
		
		Если Выборка.ТипДокументаБУ = "ПередачаТоваров" И Выборка.ТипДокументаУУ = "УЧ_СписаниеТоваров" Тогда
			
			Если СтруктураВозврата = Неопределено Тогда
				НоваяОперация = Документы.УЧ_СписаниеТоваров.СоздатьДокумент();
				НоваяОперация.Заполнить(ТекДокументСтруктура.Ссылка);
				НоваяОперация.ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
				НоваяОперация.ДополнительныеСвойства.Вставить("ДокументБУ", ТекДокументСтруктура.Ссылка);
				НоваяОперация.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				СтруктураВозврата.Вставить("ИмяФормы", "УЧ_СписаниеТоваров");	
			КонецЕсли;
			
			ЕстьСоответствие = Истина;
		КонецЕсли;
		
		Если Выборка.ТипДокументаБУ = "АвансовыйОтчет" И Выборка.ТипДокументаУУ = "УЧ_АвансовыйОтчет" Тогда
			
			Если СтруктураВозврата = Неопределено Тогда
				НоваяОперация = Документы.УЧ_АвансовыйОтчет.СоздатьДокумент();
				НоваяОперация.Заполнить(ТекДокументСтруктура.Ссылка);
				НоваяОперация.ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
				НоваяОперация.ДополнительныеСвойства.Вставить("ДокументБУ", ТекДокументСтруктура.Ссылка);
				НоваяОперация.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				СтруктураВозврата.Вставить("ИмяФормы", "УЧ_АвансовыйОтчет");	
			КонецЕсли;
			
			ЕстьСоответствие = Истина;
		КонецЕсли;
		
		Если Выборка.ТипДокументаБУ = "ВозвратТоваровОтПокупателя" И Выборка.ТипДокументаУУ = "УЧ_Возврат" Тогда
			
			Если СтруктураВозврата = Неопределено Тогда
				НоваяОперация = Документы.УЧ_Возврат.СоздатьДокумент();
				НоваяОперация.Заполнить(ТекДокументСтруктура.Ссылка);
				НоваяОперация.ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
				НоваяОперация.ДополнительныеСвойства.Вставить("ДокументБУ", ТекДокументСтруктура.Ссылка);
				НоваяОперация.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				СтруктураВозврата.Вставить("ИмяФормы", "УЧ_Возврат");	
			КонецЕсли;
			
			ЕстьСоответствие = Истина;
		КонецЕсли;
		
		Если Выборка.ТипДокументаБУ = "ВозвратТоваровПоставщику" И Выборка.ТипДокументаУУ = "УЧ_ВозвратТоваровПоставщику" Тогда
			
			Если СтруктураВозврата = Неопределено Тогда
				НоваяОперация = Документы.УЧ_ВозвратТоваровПоставщику.СоздатьДокумент();
				НоваяОперация.Заполнить(ТекДокументСтруктура.Ссылка);
				НоваяОперация.ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
				НоваяОперация.ДополнительныеСвойства.Вставить("ДокументБУ", ТекДокументСтруктура.Ссылка);
				НоваяОперация.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				СтруктураВозврата.Вставить("ИмяФормы", "УЧ_ВозвратТоваровПоставщику");	
			КонецЕсли;
			
			ЕстьСоответствие = Истина;
		КонецЕсли;
		
		Если Выборка.ТипДокументаБУ = "КорректировкаПоступления" И Выборка.ТипДокументаУУ = "УЧ_КорректировкаПоступления" Тогда
			
			Если СтруктураВозврата = Неопределено Тогда
				НоваяОперация = Документы.УЧ_КорректировкаПоступления.СоздатьДокумент();
				НоваяОперация.Заполнить(ТекДокументСтруктура.Ссылка);
				НоваяОперация.ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
				НоваяОперация.ДополнительныеСвойства.Вставить("ДокументБУ", ТекДокументСтруктура.Ссылка);
				НоваяОперация.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				СтруктураВозврата.Вставить("ИмяФормы", "УЧ_КорректировкаПоступления");	
			КонецЕсли;
			
			ЕстьСоответствие = Истина;
		КонецЕсли;
		
		Если Выборка.ТипДокументаБУ = "КорректировкаРеализации" И Выборка.ТипДокументаУУ = "УЧ_КорректировкаРеализации" Тогда
			
			Если СтруктураВозврата = Неопределено Тогда
				НоваяОперация = Документы.УЧ_КорректировкаРеализации.СоздатьДокумент();
				НоваяОперация.Заполнить(ТекДокументСтруктура.Ссылка);
				НоваяОперация.ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
				НоваяОперация.ДополнительныеСвойства.Вставить("ДокументБУ", ТекДокументСтруктура.Ссылка);
				НоваяОперация.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				СтруктураВозврата.Вставить("ИмяФормы", "УЧ_КорректировкаРеализации");	
			КонецЕсли;
			
			ЕстьСоответствие = Истина;
		КонецЕсли;
		
		Если Выборка.ТипДокументаБУ = "ТребованиеНакладная" И Выборка.ТипДокументаУУ = "УЧ_ПеремещениеМатериаловВПроизводство" Тогда
			
			Если СтруктураВозврата = Неопределено Тогда
				НоваяОперация = Документы.УЧ_ПеремещениеМатериаловВПроизводство.СоздатьДокумент();
				НоваяОперация.Заполнить(ТекДокументСтруктура.Ссылка);
				НоваяОперация.ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
				НоваяОперация.ДополнительныеСвойства.Вставить("ДокументБУ", ТекДокументСтруктура.Ссылка);
				НоваяОперация.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				СтруктураВозврата.Вставить("ИмяФормы", "УЧ_ПеремещениеМатериаловВПроизводство");	
			КонецЕсли;
			
			ЕстьСоответствие = Истина;
		КонецЕсли;
		
		Если Выборка.ТипДокументаБУ = "ОтчетПроизводстваЗаСмену" И Выборка.ТипДокументаУУ = "УЧ_ВыпускПродукции" Тогда
			
			Если СтруктураВозврата = Неопределено Тогда
				НоваяОперация = Документы.УЧ_ВыпускПродукции.СоздатьДокумент();
				НоваяОперация.Заполнить(ТекДокументСтруктура.Ссылка);
				НоваяОперация.ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
				НоваяОперация.ДополнительныеСвойства.Вставить("ДокументБУ", ТекДокументСтруктура.Ссылка);
				НоваяОперация.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				СтруктураВозврата.Вставить("ИмяФормы", "УЧ_ВыпускПродукции");	
			КонецЕсли;
			
			ЕстьСоответствие = Истина;
		КонецЕсли;
		
		Если Выборка.ТипДокументаБУ = "ОтчетОРозничныхПродажах" И Выборка.ТипДокументаУУ = "УЧ_Реализация" Тогда
			
			Если СтруктураВозврата = Неопределено Тогда
				НоваяОперация = Документы.УЧ_Реализация.СоздатьДокумент();
				НоваяОперация.Заполнить(ТекДокументСтруктура.Ссылка);
				НоваяОперация.ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
				НоваяОперация.ДополнительныеСвойства.Вставить("ДокументБУ", ТекДокументСтруктура.Ссылка);
				НоваяОперация.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				СтруктураВозврата.Вставить("ИмяФормы", "УЧ_Реализация");	
			КонецЕсли;
			
			ЕстьСоответствие = Истина;
		КонецЕсли;
		
		Если Выборка.ТипДокументаБУ = "РозничнаяПродажа" И Выборка.ТипДокументаУУ = "УЧ_Реализация" Тогда
			
			Если СтруктураВозврата = Неопределено Тогда
				НоваяОперация = Документы.УЧ_Реализация.СоздатьДокумент();
				НоваяОперация.Заполнить(ТекДокументСтруктура.Ссылка);
				НоваяОперация.ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
				НоваяОперация.ДополнительныеСвойства.Вставить("ДокументБУ", ТекДокументСтруктура.Ссылка);
				НоваяОперация.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				СтруктураВозврата.Вставить("ИмяФормы", "УЧ_Реализация");	
			КонецЕсли;
			
			ЕстьСоответствие = Истина;
		КонецЕсли;
		
		Если Выборка.ТипДокументаБУ = "ПеремещениеТоваров" И Выборка.ТипДокументаУУ = "УЧ_ПеремещениеТоваров" Тогда
			
			Если СтруктураВозврата = Неопределено Тогда
				НоваяОперация = Документы.УЧ_ПеремещениеТоваров.СоздатьДокумент();
				НоваяОперация.Заполнить(ТекДокументСтруктура.Ссылка);
				НоваяОперация.ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
				НоваяОперация.ДополнительныеСвойства.Вставить("ДокументБУ", ТекДокументСтруктура.Ссылка);
				НоваяОперация.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				СтруктураВозврата.Вставить("ИмяФормы", "УЧ_ПеремещениеТоваров");	
			КонецЕсли;
			
			ЕстьСоответствие = Истина;
		КонецЕсли;
		
		Если Выборка.ТипДокументаУУ = "Исключено" Тогда
			
			Если СтруктураВозврата = Неопределено Тогда
				НоваяОперация = Документы.УЧ_Операция.СоздатьДокумент();
				НоваяОперация.ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
				НоваяОперация.ДополнительныеСвойства.Вставить("ДокументБУ", ТекДокументСтруктура.Ссылка);
				НоваяОперация.Предприятие = ТекДокументСтруктура.Ссылка.Организация.Предприятие;
				НоваяОперация.Организация = ТекДокументСтруктура.Ссылка.Организация;
				НоваяОперация.Дата = Выборка.Период;
				НоваяОперация.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				Сообщить("Тип документа добавлен в исключения");
			КонецЕсли;
			
			ЕстьСоответствие = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Если НЕ ЕстьСоответствие Тогда
		
		Если СтруктураВозврата = Неопределено Тогда
			НоваяОперация = Документы.УЧ_Операция.СоздатьДокумент();
			НоваяОперация.ДополнительныеСвойства.Вставить("ДокументБУ", ТекДокументСтруктура.Ссылка);
			НоваяОперация.Заполнить(ТекДокументСтруктура.Ссылка);
			НоваяОперация.Записать(РежимЗаписиДокумента.Проведение);
		Иначе
			СтруктураВозврата.Вставить("ИмяФормы", "УЧ_Операция");	
		КонецЕсли;
		
		ЕстьСоответствие = Истина;
	КонецЕсли;
	
	Если СтруктураВозврата = Неопределено Тогда
		НаборЗаписей = РегистрыСведений.сабОбработкаДокументов.СоздатьМенеджерЗаписи();
		НаборЗаписей.ДокументБУ = ТекДокументСтруктура.Ссылка;
		НаборЗаписей.ДокументУУ = НоваяОперация.Ссылка;
		НаборЗаписей.Автор = ПараметрыСеанса.ТекущийПользователь;
		НаборЗаписей.ДатаОбработки = ТекущаяДата();
		НаборЗаписей.Записать();
	КонецЕсли; 
	
	//ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Функция ТекстЗапросаНеобработанных(ВыбратьПервые = Неопределено) Экспорт
	//выбрать первые используется только в фоновом задании
	
	Возврат "ВЫБРАТЬ " + ?(ВыбратьПервые = Неопределено, "", "ПЕРВЫЕ " + Формат(ВыбратьПервые, "ЧРГ=''")) + "
	|	ЖурналДокументовЖурналОпераций.Дата КАК Дата,
	|	ЖурналДокументовЖурналОпераций.Номер КАК Номер,
	|	ЖурналДокументовЖурналОпераций.Организация КАК Организация,
	|	ЖурналДокументовЖурналОпераций.Информация КАК Информация,
	|	ЖурналДокументовЖурналОпераций.СуммаДокумента КАК СуммаДокумента,
	|	ЖурналДокументовЖурналОпераций.ВидОперации КАК ВидОперации,
	|	ЖурналДокументовЖурналОпераций.Комментарий КАК Комментарий,
	|	ЖурналДокументовЖурналОпераций.Тип КАК Тип,
	|	сабСоответствиеДокументов.ДокументУУ КАК ДокументУУ,
	|	ЖурналДокументовЖурналОпераций.Ссылка КАК Ссылка,
	|	Хозрасчетный.Регистратор КАК Регистратор
	|ИЗ
	|	ЖурналДокументов.ЖурналОпераций КАК ЖурналДокументовЖурналОпераций
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.сабОбработкаДокументов КАК сабСоответствиеДокументов
	|		ПО ЖурналДокументовЖурналОпераций.Ссылка = сабСоответствиеДокументов.ДокументБУ
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный КАК Хозрасчетный
	|		ПО ЖурналДокументовЖурналОпераций.Ссылка = Хозрасчетный.Регистратор
	|			И (Хозрасчетный.НомерСтроки = 1)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.сабДокументОшибкаФоновогоПроведения КАК сабДокументОшибкаФоновогоПроведения
	|		ПО ЖурналДокументовЖурналОпераций.Ссылка = сабДокументОшибкаФоновогоПроведения.ДокументБУ
	|ГДЕ
	|	сабСоответствиеДокументов.ДокументУУ ЕСТЬ NULL
	|	И НЕ Хозрасчетный.Регистратор ЕСТЬ NULL
	|	И НЕ ТипЗначения(ЖурналДокументовЖурналОпераций.Ссылка) В (&МассивИсклТипов)
	|	И ЖурналДокументовЖурналОпераций.Дата >= &Дата
	|	И ЖурналДокументовЖурналОпераций.ПометкаУдаления = Ложь"
	+ ?(ВыбратьПервые = Неопределено, "", " И сабДокументОшибкаФоновогоПроведения.ДокументБУ ЕСТЬ NULL") + "
	|	И (ЖурналДокументовЖурналОпераций.Проведен = Истина ИЛИ ТипЗначения(ЖурналДокументовЖурналОпераций.Ссылка) = Тип(Документ.ОперацияБух))
	|	И ЖурналДокументовЖурналОпераций.Организация В
	|			(ВЫБРАТЬ
	|				сабСоответствияОрганизацийПредприятиям.Организация КАК Организация
	|			ИЗ
	|				РегистрСведений.сабСоответствияОрганизацийПредприятиям КАК сабСоответствияОрганизацийПредприятиям
	|			ГДЕ
	|				НЕ сабСоответствияОрганизацийПредприятиям.Предприятие = ЗНАЧЕНИЕ(Справочник.Предприятия.ПустаяСсылка))" 
	 + ?(ВыбратьПервые = Неопределено, "", "
	 |УПОРЯДОЧИТЬ ПО
	|	Дата
	|АВТОУПОРЯДОЧИВАНИЕ");
	
	
КонецФункции // ()

Функция ТекстЗапросаНеобработанныхРозница(ВыбратьПервые = Неопределено) Экспорт
	//выбрать первые используется только в фоновом задании
	
	Возврат "ВЫБРАТЬ " + ?(ВыбратьПервые = Неопределено, "", "ПЕРВЫЕ " + Формат(ВыбратьПервые, "ЧРГ=''")) + "
	|	ЖурналДокументовЖурналОпераций.Дата КАК Дата,
	|	ЖурналДокументовЖурналОпераций.Номер КАК Номер,
	|	ЖурналДокументовЖурналОпераций.Организация КАК Организация,
	|	"""" КАК Информация,
	|	ЖурналДокументовЖурналОпераций.СуммаДокумента КАК СуммаДокумента,
	|	ЖурналДокументовЖурналОпераций.ВидОперации КАК ВидОперации,
	|	ЖурналДокументовЖурналОпераций.Комментарий КАК Комментарий,
	|	ТипЗначения(ЖурналДокументовЖурналОпераций.Ссылка) КАК Тип,
	|	сабСоответствиеДокументов.ДокументУУ КАК ДокументУУ,
	|	ЖурналДокументовЖурналОпераций.Ссылка КАК Ссылка,
	|	ЖурналДокументовЖурналОпераций.Ссылка КАК Регистратор
	|ИЗ
	|	Документ.РозничнаяПродажа КАК ЖурналДокументовЖурналОпераций
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.сабОбработкаДокументов КАК сабСоответствиеДокументов
	|		ПО ЖурналДокументовЖурналОпераций.Ссылка = сабСоответствиеДокументов.ДокументБУ
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.сабДокументОшибкаФоновогоПроведения КАК сабДокументОшибкаФоновогоПроведения
	|		ПО ЖурналДокументовЖурналОпераций.Ссылка = сабДокументОшибкаФоновогоПроведения.ДокументБУ
	|ГДЕ
	|	сабСоответствиеДокументов.ДокументУУ ЕСТЬ NULL
	|	И ЖурналДокументовЖурналОпераций.Дата >= &Дата
	|	И ЖурналДокументовЖурналОпераций.ПометкаУдаления = Ложь
	|	И ЖурналДокументовЖурналОпераций.ПометкаУдаления = Ложь"
	+ ?(ВыбратьПервые = Неопределено, "", " И сабДокументОшибкаФоновогоПроведения.ДокументБУ ЕСТЬ NULL") + "
	|	И ЖурналДокументовЖурналОпераций.Организация В
	|			(ВЫБРАТЬ
	|				сабСоответствияОрганизацийПредприятиям.Организация КАК Организация
	|			ИЗ
	|				РегистрСведений.сабСоответствияОрганизацийПредприятиям КАК сабСоответствияОрганизацийПредприятиям
	|			ГДЕ
	|				НЕ сабСоответствияОрганизацийПредприятиям.Предприятие = ЗНАЧЕНИЕ(Справочник.Предприятия.ПустаяСсылка))" 
	 + ?(ВыбратьПервые = Неопределено, "", "
	 |УПОРЯДОЧИТЬ ПО
	|	Дата
	|АВТОУПОРЯДОЧИВАНИЕ");
	
КонецФункции // ()

Функция ТекстЗапросаИзмененные(ВыбратьПервые = Неопределено) Экспорт
	
	Возврат "ВЫБРАТЬ " + ?(ВыбратьПервые = Неопределено, "", "ПЕРВЫЕ " + Формат(ВыбратьПервые, "ЧРГ=''")) + "
	|ЖурналДокументовЖурналОпераций.Дата КАК Дата,
	|ЖурналДокументовЖурналОпераций.Номер КАК Номер,
	|ЖурналДокументовЖурналОпераций.Организация КАК Организация,
	|ЖурналДокументовЖурналОпераций.Информация КАК Информация,
	|ЖурналДокументовЖурналОпераций.СуммаДокумента КАК СуммаДокумента,
	|ЖурналДокументовЖурналОпераций.ВидОперации КАК ВидОперации,
	|ЖурналДокументовЖурналОпераций.Комментарий КАК Комментарий,
	|ЖурналДокументовЖурналОпераций.Тип КАК Тип,
	|сабСоответствиеДокументов.ДокументУУ КАК ДокументУУ,
	|ЖурналДокументовЖурналОпераций.Ссылка КАК Ссылка
	|ИЗ
	|ЖурналДокументов.ЖурналОпераций КАК ЖурналДокументовЖурналОпераций
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.сабОбработкаДокументов КАК сабСоответствиеДокументов
	|	ПО ЖурналДокументовЖурналОпераций.Ссылка = сабСоответствиеДокументов.ДокументБУ
	|		И (сабСоответствиеДокументов.Модифицирован = ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.сабДокументОшибкаФоновогоПроведения КАК сабДокументОшибкаФоновогоПроведения
	|		ПО ЖурналДокументовЖурналОпераций.Ссылка = сабДокументОшибкаФоновогоПроведения.ДокументБУ
	|	ГДЕ
	|ЖурналДокументовЖурналОпераций.Дата >= &Дата"
	+ ?(ВыбратьПервые = Неопределено, "", " И сабДокументОшибкаФоновогоПроведения.ДокументБУ ЕСТЬ NULL");
	
КонецФункции // ()

Функция ПолучитьИзмененныеДокументы(ВыбратьПервые) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ " + ?(ВыбратьПервые = Неопределено, "", "ПЕРВЫЕ " + Формат(ВыбратьПервые, "ЧРГ=''")) + "
	|	сабОбработкаДокументов.ДокументБУ КАК ДокументБУ,
	|	сабОбработкаДокументов.ДокументУУ КАК ДокументУУ,
	|	сабОбработкаДокументов.Модифицирован КАК Модифицирован,
	|	сабОбработкаДокументов.Автор КАК Автор,
	|	сабОбработкаДокументов.ДатаОбработки КАК ДатаОбработки,
	|	сабОбработкаДокументов.Комментарий КАК Комментарий,
	|	сабОбработкаДокументов.ДокументБУ.Дата КАК ДокументБУДата
	|ИЗ
	|	РегистрСведений.сабОбработкаДокументов КАК сабОбработкаДокументов
	|ГДЕ
	|	сабОбработкаДокументов.Модифицирован = Истина
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДокументБУДата
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	//Запрос.УстановитьПараметр("", );
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выгрузить();
	
	Возврат Выборка;
	
	
КонецФункции // ()



