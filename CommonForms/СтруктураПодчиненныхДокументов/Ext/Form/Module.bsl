﻿
&НаКлиенте
Процедура ДеревоДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ПоказатьЗначение(,Элемент.ТекущиеДанные.Ссылка);
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбъектыМетаданных = ДеревоДокументов.ПолучитьЭлементы();
	
	Документ = ?(ЗначениеЗаполнено(Документ), Документ, Параметры.Документ);
	Дер = ОдновитьДеревоЗначений(Документ,, Документ, РасширеннаяДетализация, Документ);
	ЗначениеВРеквизитФормы(Дер, "ДеревоДокументов");
	
	ДобавляемыеРеквизиты = Новый Массив; 
	Реквизит = Новый РеквизитФормы("Комментарий", Новый ОписаниеТипов("СписокЗначений")); 
	ДобавляемыеРеквизиты.Добавить(Реквизит); 
	ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	Заголовок = Строка(Документ);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОдновитьДеревоЗначений(Ссылка, Дер = Неопределено, ПараметрКоманды = Неопределено, РасширеннаяДетализация, Документ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Дер = Неопределено Тогда
		Дер = Новый ДеревоЗначений;
		Дер.Колонки.Добавить("ТипДокумента");
		Дер.Колонки.Добавить("Ссылка");
		Дер.Колонки.Добавить("Дата");
		Дер.Колонки.Добавить("Номер");
		Дер.Колонки.Добавить("ТекущаяЗадача");
		Дер.Колонки.Добавить("Предприятие");
		Дер.Колонки.Добавить("КартинкаДокумента");
		Дер.Колонки.Добавить("Количество");
		Дер.Колонки.Добавить("ТекущийИсполнитель");
		Дер.Колонки.Добавить("ТочкаМаршрута");
		Дер.Колонки.Добавить("Подразделение");
		Дер.Колонки.Добавить("ТекущийДокумент");
		Дер.Колонки.Добавить("Автор");
		Дер.Колонки.Добавить("СуммаДокумента");
	КонецЕсли;
	
	Если НЕ ТипЗнч(Ссылка) = Тип("Массив") Тогда
		ТекРодители = Новый Массив;
		ТекРодители.Добавить(Ссылка);
		//ищем исконного родителя
		
		ТипМетаданныхСсылки = Ссылка.Метаданные();
		МассивТиповРеквизитов = Новый Массив;
		МассивТиповРеквизитов.Добавить(ТипМетаданныхСсылки.Реквизиты);
		МассивТиповРеквизитов.Добавить(ТипМетаданныхСсылки.СтандартныеРеквизиты);
		Для каждого ТекТипРеквизитов Из МассивТиповРеквизитов Цикл
			Для каждого ТекРеквизит Из ТекТипРеквизитов Цикл
				Для каждого ТекТип Из ТекРеквизит.Тип.Типы() Цикл
					Если НЕ ТекТип = Тип("Дата") И НЕ ТекТип = Тип("Булево") И НЕ ТекТип = Тип("Число") И НЕ ТекТип = Тип("Строка") И НЕ ТекТип = Тип("ХранилищеЗначения") Тогда
						Типп = Новый(ТекТип);
						Если (НЕ Метаданные.Документы.Найти(Типп.Метаданные().Имя) = Неопределено) И НЕ ТекРеквизит.Имя = "Ссылка" Тогда
							Если ЗначениеЗаполнено(Ссылка[ТекРеквизит.Имя]) И ТипЗнч(Типп) = ТипЗнч(Ссылка[ТекРеквизит.Имя]) И НЕ Ссылка[ТекРеквизит.Имя] = Документ Тогда
								Дер = ОдновитьДеревоЗначений(Ссылка[ТекРеквизит.Имя],,ПараметрКоманды, РасширеннаяДетализация, Документ);
								Возврат Дер;
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла; 
			КонецЦикла;
		КонецЦикла;//конец поиска исконного родителя
		
		НоваяСтрока = Дер.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Ссылка);
		ЗаполнитьСуммуДокументаДляТипов(НоваяСтрока, Ссылка);
		НоваяСтрока.ТекущийДокумент = (Ссылка = ПараметрКоманды);
		Попытка
			НоваяСтрока.КартинкаДокумента = ?(Ссылка.Проведен, 1, ?(Ссылка.ПометкаУдаления, 2, 0));
		Исключение
			НоваяСтрока.КартинкаДокумента = ?(Ссылка.ПометкаУдаления, 2, 0);		
		КонецПопытки;
		
	Иначе
		ТекРодители = Ссылка;
	КонецЕсли;
	
	Для каждого ТекСсылка Из ТекРодители Цикл
		
		ТипМетаданныхСсылки = ТекСсылка.Метаданные();
		ТаблицаПодчиненных = Новый ТаблицаЗначений;
		ТаблицаПодчиненных.Колонки.Добавить("Уровень");
		ТаблицаПодчиненных.Колонки.Добавить("ИмяДокумента");
		ТаблицаПодчиненных.Колонки.Добавить("ИмяРеквизита");
		ТаблицаПодчиненных.Колонки.Добавить("ИмяОбъектаМетаданных");
		
		СоответствиеМетаданных = Новый Соответствие;
		СоответствиеМетаданных.Вставить(Метаданные.Документы, "Документ");
		СоответствиеМетаданных.Вставить(Метаданные.Справочники, "Справочник");
		
		Если РасширеннаяДетализация Тогда
			СоответствиеМетаданных.Вставить(Метаданные.БизнесПроцессы, "БизнесПроцесс");
			СоответствиеМетаданных.Вставить(Метаданные.Задачи, "Задача");
			//СоответствиеМетаданных.Вставить(Метаданные.Справочники, "Справочник");
		КонецЕсли;
		
		Для каждого ТекОбъектМетаданных Из СоответствиеМетаданных Цикл
			Для каждого ТекДокумент Из ТекОбъектМетаданных.Ключ Цикл
				//Если ТипМетаданныхСсылки = ТекДокумент Тогда
				//	Если Не ТекДокумент.Имя = "БП_Поручение" Тогда
				//		Продолжить; //обрубаем однотипные доки			
				//	КонецЕсли;
				//КонецЕсли;
				//заменил на условие по ссылке							
				
				//для справочников отключаем, кроме опознавания
				Если ТекОбъектМетаданных.Значение = "Справочник" И НЕ ТекДокумент.Имя = "ОпознаваниеПлатежей" Тогда
					Продолжить;				
				КонецЕсли;
				
				МассивТиповРеквизитов = Новый Массив;
				МассивТиповРеквизитов.Добавить(ТекДокумент.Реквизиты);
				МассивТиповРеквизитов.Добавить(ТекДокумент.СтандартныеРеквизиты);
				Для каждого ТекТипРеквизитов Из МассивТиповРеквизитов Цикл
					Для каждого ТекРеквизит Из ТекТипРеквизитов Цикл
						Для каждого ТекТип Из ТекРеквизит.Тип.Типы() Цикл
							Если НЕ ТекТип = Тип("Дата") И НЕ ТекТип = Тип("Булево") И НЕ ТекТип = Тип("Число") И НЕ ТекТип = Тип("Строка") И НЕ ТекТип = Тип("ХранилищеЗначения") И НЕ ТекРеквизит.Имя = "Ссылка" Тогда
								Типп = Новый(ТекТип);
								Если ТипЗнч(ТекСсылка) = ТипЗнч(Типп) Тогда
									НоваяСтрока = ТаблицаПодчиненных.Добавить();
									НоваяСтрока.Уровень = 1;
									НоваяСтрока.ИмяДокумента = ТекДокумент.Имя;
									НоваяСтрока.ИмяРеквизита = ТекРеквизит.Имя;
									НоваяСтрока.ИмяОбъектаМетаданных = СоответствиеМетаданных[ТекОбъектМетаданных.Ключ];
								КонецЕсли;
							КонецЕсли;
						КонецЦикла; 
					КонецЦикла;
				КонецЦикла; 
				
			КонецЦикла;
			
			
		КонецЦикла;
		
		//частные случаи
		ОтобранныеСтрокиТЧ = ТаблицаПодчиненных.НайтиСтроки(Новый Структура("ИмяДокумента, ИмяРеквизита", "Задача", "Заявка"));
		Для каждого ТекСтрока Из ОтобранныеСтрокиТЧ Цикл
			ТаблицаПодчиненных.Удалить(ТекСтрока);			
		КонецЦикла; 
		//конец частных случаев
		
		МассивПодчиненных = Новый Массив;
		Для каждого ТекСтрока Из ТаблицаПодчиненных Цикл
			
			Если ТекСтрока.ИмяОбъектаМетаданных = "Документ" Тогда
				ЧастьЗапроса = ",
				|	ВЫБОР
				|		КОГДА Д_ЗаявкаНаОтгрузкуНовая.Проведен
				|			ТОГДА 1
				|		ИНАЧЕ ВЫБОР
				|				КОГДА Д_ЗаявкаНаОтгрузкуНовая.ПометкаУдаления
				|					ТОГДА 2
				|				ИНАЧЕ 0
				|			КОНЕЦ
				|	КОНЕЦ КАК КартинкаДокумента";
			Иначе
				ЧастьЗапроса = ",
				|	1 КАК КартинкаДокумента";	
			КонецЕсли;
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|*" + ЧастьЗапроса + "
			|ИЗ
			|	" + ТекСтрока.ИмяОбъектаМетаданных + "." + ТекСтрока.ИмяДокумента + " КАК Д_ЗаявкаНаОтгрузкуНовая
			|ГДЕ
			|	Д_ЗаявкаНаОтгрузкуНовая." + ТекСтрока.ИмяРеквизита + " = &ДокументОснование";
			Запрос.УстановитьПараметр("ДокументОснование", ТекСсылка);
			
			Результат = Запрос.Выполнить();
			Выборка = Результат.Выбрать();
			
			Пока Выборка.Следующий() Цикл
				Если Дер.Строки.Количество() Тогда
					ТекРодитель = Дер.Строки.Найти(ТекСсылка, "Ссылка", Истина);
				Иначе
					ТекРодитель = Дер;
				КонецЕсли;
				Если НЕ ТекРодитель = Неопределено И Дер.Строки.Найти(Выборка.Ссылка, "Ссылка", Истина) = Неопределено Тогда
					ДобавлятьПодчиненный = Истина;
					//Если ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.Д_ЗаявкаНаОтгрузку") И ТипЗнч(Выборка.Ссылка) = Тип("ДокументСсылка.Д_ЗаявкаНаОтгрузку") И НЕ (Выборка.Ссылка = ПараметрКоманды) Тогда
					//	ДобавлятьПодчиненный = Ложь;					
					//КонецЕсли;
					Если ДобавлятьПодчиненный Тогда
						НоваяСтрока = ТекРодитель.Строки.Добавить();
						ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
						ЗаполнитьСуммуДокументаДляТипов(НоваяСтрока, Выборка);
						НоваяСтрока.ТекущийДокумент = (Выборка.Ссылка = ПараметрКоманды);				
						МассивПодчиненных.Добавить(Выборка.Ссылка);
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
		КонецЦикла;
		Если МассивПодчиненных.Количество() Тогда
			ОдновитьДеревоЗначений(МассивПодчиненных, Дер, ПараметрКоманды, РасширеннаяДетализация, Документ);
		//Иначе
		//	Прервать;	
		КонецЕсли;
	КонецЦикла; 
	
	УстановитьПривилегированныйРежим(Ложь);	
	
	Возврат Дер;
	
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаполнитьСуммуДокументаДляТипов(НоваяСтрока, Ссылка)
	
	Попытка
		
		Если ТипЗнч(Ссылка.Ссылка) = Тип("ДокументСсылка.Д_ЗаявкаНаФинансирование") Тогда
			НоваяСтрока.СуммаДокумента = Ссылка.Сумма;
		ИначеЕсли ТипЗнч(Ссылка.Ссылка) = Тип("ДокументСсылка.Д_ЗаявкаНаСогласованиеДоговора") Тогда
			НоваяСтрока.СуммаДокумента = Ссылка.Сумма;
		КонецЕсли;
		
	Исключение
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ДетализацияПриИзменении(Элемент)
	Обновить();
	Элементы.ДеревоДокументов.Развернуть(ДеревоДокументов.ПолучитьЭлементы().Получить(0).ПолучитьИдентификатор(), Истина);
КонецПроцедуры

&НаСервере
Процедура Обновить()
	Дер = ОдновитьДеревоЗначений(Документ,, Документ, РасширеннаяДетализация, Документ);
	ЗначениеВРеквизитФормы(Дер, "ДеревоДокументов");
КонецПроцедуры

&НаСервере
Процедура ПровестиНаСервере1(ТекСсылка, ИндексКартинки)
	
	ТекОб = ТекСсылка.ПолучитьОбъект();
	ТекОб.Проведен = Истина;
	ТекОб.Записать(РежимЗаписиДокумента.Проведение);
	
	ОбновитьКартинку(ТекОб, ИндексКартинки);
	
КонецПроцедуры

&НаКлиенте
Процедура Провести1(Команда)
	ПровестиНаСервере1(Элементы.ДеревоДокументов.ТекущиеДанные.Ссылка, Элементы.ДеревоДокументов.ТекущиеДанные.КартинкаДокумента);
КонецПроцедуры

&НаСервере
Процедура ОтменитьПроведениеНаСервере(ТекСсылка, ИндексКартинки)
	
	ТекОб = ТекСсылка.ПолучитьОбъект();
	ТекОб.Проведен = Ложь;
	ТекОб.Записать(РежимЗаписиДокумента.Запись);
	
	ОбновитьКартинку(ТекОб, ИндексКартинки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПроведение(Команда)
	ОтменитьПроведениеНаСервере(Элементы.ДеревоДокументов.ТекущиеДанные.Ссылка, Элементы.ДеревоДокументов.ТекущиеДанные.КартинкаДокумента);
КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	ТекСсылка = Элементы.ДеревоДокументов.ТекущиеДанные.Ссылка;
	ПоказатьЗначение(, ТекСсылка);
КонецПроцедуры

&НаСервере
Процедура ПометитьНаУдалениеНаСервере(ТекСсылка, ИндексКартинки)
	
	ТекОб = ТекСсылка.ПолучитьОбъект();
	ТекОб.УстановитьПометкуУдаления(Не ТекОб.ПометкаУдаления);
	ТекОб.Записать(РежимЗаписиДокумента.Запись);
	
	ОбновитьКартинку(ТекОб, ИндексКартинки);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКартинку(ТекОб, ИндексКартинки)
	
	Попытка
		ИндексКартинки = ?(ТекОб.Проведен, 1, ?(ТекОб.ПометкаУдаления, 2, 0));
	Исключение
		ИндексКартинки = ?(ТекОб.ПометкаУдаления, 2, 0);		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдаление(Команда)
	ПометкаУдаления = БюджетныйНаСервере.ВернутьРеквизит(Элементы.ДеревоДокументов.ТекущиеДанные.Ссылка, "ПометкаУдаления");
	ТекстВопроса = ?(ПометкаУдаления, "Снять пометку удаления?", "Установить пометку удаления?");
	ПоказатьВопрос(Новый ОписаниеОповещения("ПометитьНаУдалениеЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдалениеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПометитьНаУдалениеНаСервере(Элементы.ДеревоДокументов.ТекущиеДанные.Ссылка, Элементы.ДеревоДокументов.ТекущиеДанные.КартинкаДокумента);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДеревоДокументовПередУдалением(Элемент, Отказ)
	Отказ = Истина;
	ПометитьНаУдаление(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоДокументовПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	Изменить(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоДокументовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоДокументовПриАктивизацииСтроки(Элемент)
	УстановитьДоступностьКомандНаСервере(Элементы.ДеревоДокументов.ТекущиеДанные.Ссылка);	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьКомандНаСервере(ДокументСсылка)
	ЭтоДокументБизнесПроцесса = Ложь;
	ЕстьПрава = ПравоДоступа("ИнтерактивноеПроведение", ДокументСсылка.Метаданные());
	Элементы.ФормаПровести.Доступность = НЕ ЭтоДокументБизнесПроцесса И ЕстьПрава;
	Элементы.ФормаОтменитьПроведение.Доступность = НЕ ЭтоДокументБизнесПроцесса И ЕстьПрава;
	Элементы.ФормаПометитьНаУдаление.Доступность = НЕ ЭтоДокументБизнесПроцесса И ЕстьПрава;
КонецПроцедуры


