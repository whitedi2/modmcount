﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	РеквыЗаказа = БюджетныйНаСервере.ВернутьРеквизиты(ПараметрКоманды, "Организация, ПродажаВРозницу, БезвозмезднаяПередача");
	ДопПараметры = Новый Структура;
	ПараметрыФормы = Новый Структура("Основание", ПараметрКоманды);
	ДопПараметры.Вставить("Документ", "УЧ_Реализация");
	ДопПараметры.Вставить("ДанныеЗаполнения", ПараметрКоманды);
	ДопПараметры.Вставить("Основание", ПараметрКоманды);
	//ЗаполнитьДокументы(ДопПараметры);
	СоздатьДокументРеализации(ДопПараметры);
	СоздатьДокументПоступления(ДопПараметры);
	
	
КонецПроцедуры 

Процедура ЗаполнитьДокументы(ДопПараметры)
	Отказ = Ложь;
	Если ДопПараметры.Свойство("Документ") Тогда
		Если ДопПараметры.Документ = "УЧ_Реализация" Тогда
			НоваяРеализация = Документы.УЧ_Реализация.СоздатьДокумент();
			Попытка
				НоваяРеализация.Заполнить(ДопПараметры.ДанныеЗаполнения);
				НоваяРеализация.Автор = ПараметрыСеанса.ТекущийПользователь;
				НоваяРеализация.АдресДоставки = ДопПараметры.ДанныеЗаполнения.АдресДоставки;
				//НоваяРеализация.ДополнительныеСвойства.Вставить("НеИзменятьСтатусЗаказа", Истина); 
			Исключение 
				Отказ = Истина;
				СтрокаСообщения = ОписаниеОшибки();
				НомерСимвола = СтрНайти(СтрокаСообщения,"}"); 
				Пока НомерСимвола > 0 Цикл
					СтрокаСообщения = Прав(СтрокаСообщения, СтрДлина(СтрокаСообщения) - (НомерСимвола+1)); 
					НомерСимвола = СтрНайти(СтрокаСообщения,"}"); 
				КонецЦикла;;
				Сообщить(СтрокаСообщения);
			КонецПопытки;
			
			//ПараметрыФормы = Новый Структура("Ключ", НоваяРеализация);
			//ОткрытьФорму("Документ.УЧ_Реализация.Форма.ФормаДокумента", ПараметрыФормы);
			
			//НоваяРеализация.ПолучитьФорму().Открыть();
			
			//ПараметрыФормы = Новый Структура("Основание", Объект.Ссылка);
			//ОткрытьФорму("Документ.УЧ_Реализация.Форма.ФормаДокумента", ПараметрыФормы);
			
			//ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ДопПараметры.ДанныеЗаполнения);
			//фНовыйДокумент = ПолучитьФорму("Документ.УЧ_Реализация.Форма.ФормаДокумента", ПараметрыФормы, ЭтаФорма);
			//фНовыйДокумент.Открыть();			
			
			//Если НЕ Отказ Тогда 
			//	Попытка
			//		НоваяРеализация.Записать(РежимЗаписиДокумента.Проведение);
			//	Исключение
			//		НоваяРеализация.Записать(РежимЗаписиДокумента.Запись); 
			//		РезультатЗаписиОсновногоДокумента = "(записан, необходимо провести вручную)";
			//	КонецПопытки;
			//	Сообщить("Созданы документы: " + НоваяРеализация.Ссылка + РезультатЗаписиОсновногоДокумента);
			//КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокументРеализации(ДопПараметры)
	Форма = ПолучитьФорму("Документ.УЧ_Реализация.Форма.ФормаДокумента",ДопПараметры);
	ДанныеФормы = Форма.Объект;
	ЗаполнитьДокументРеализацииНаСервере(ДанныеФормы,ДопПараметры);
	КопироватьДанныеФормы(ДанныеФормы, Форма.Объект);
	Форма.Открыть();
КонецПроцедуры

&НаСервере
Функция ЗаполнитьДокументРеализацииНаСервере(ДанныеФормы,ДопПараметры);
	Док = ДанныеФормыВЗначение(ДанныеФормы, Тип("ДокументОбъект.УЧ_Реализация"));
	Док.Заполнить(ДопПараметры.ДанныеЗаполнения);
	
	ОрганизацияПродажи = Справочники.сабМониторВнедрения.НайтиПоНаименованию("ОрганизацияПродажи", Истина).Значение;
	СкладПродажи = Справочники.сабМониторВнедрения.НайтиПоНаименованию("СкладПродажи", Истина).Значение;
	
	Док.Организация = ОрганизацияПродажи;
	Док.Склад = СкладПродажи;
	
	СтруктураОтбора = Новый Структура;
  СтруктураОтбора.Вставить("Организация", ОрганизацияПродажи);
  СтруктураРесурсов = РегистрыСведений.сабСоответствияОрганизацийПредприятиям.Получить(СтруктураОтбора);
	Док.Предприятие = СтруктураРесурсов.Предприятие;
	
	РеквизитОрганизация = ДопПараметры.ДанныеЗаполнения.Организация;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Контрагенты.Ссылка КАК Контрагент
	               |ИЗ
	               |	Справочник.Контрагенты КАК Контрагенты
	               |ГДЕ
	               |	Контрагенты.ИНН = &ИНН
	               |	И Контрагенты.КПП = &КПП";
	
	Запрос.УстановитьПараметр("ИНН", РеквизитОрганизация.ИНН);
	Запрос.УстановитьПараметр("КПП", РеквизитОрганизация.КПП);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Док.Контрагент = Выборка.Контрагент;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДоговорыКонтрагентов.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеДоговорыКонтрагента КАК ОсновныеДоговорыКонтрагента
		|		ПО ОсновныеДоговорыКонтрагента.Договор.Ссылка = ДоговорыКонтрагентов.Ссылка
		|ГДЕ
		|	ДоговорыКонтрагентов.Владелец = &Владелец
		|	И ДоговорыКонтрагентов.Организация = &Организация
		|	И НЕ ОсновныеДоговорыКонтрагента.Договор ЕСТЬ NULL";
	
	//Запрос.УстановитьПараметр("ВидДоговора", Перечисления.ВидыДоговоровКонтрагентов.СПокупателем);
	Запрос.УстановитьПараметр("Владелец", Док.Контрагент);
	Запрос.УстановитьПараметр("Организация", Док.Организация);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Док.Договор = ВыборкаДетальныеЗаписи.Ссылка;
	КонецЦикла;
	
	//Док.Договор = Справочники.ДоговорыКонтрагентов.НайтиПоРеквизиту("Организация",Док.Организация,,Док.Контрагент); 
	
	Док.ПодразделениеКонтрагента = Справочники.ПодразделенияКонтрагентов.ПустаяСсылка();
	
	ЗначениеВДанныеФормы(Док,ДанныеФормы);
КонецФункции

&НаКлиенте
Процедура СоздатьДокументПоступления(ДопПараметры)
	Форма = ПолучитьФорму("Документ.УЧ_ПоступлениеТоваров.Форма.ФормаДокумента",ДопПараметры);
	ДанныеФормы = Форма.Объект;
	ЗаполнитьДокументПоступленияНаСервере(ДанныеФормы,ДопПараметры);
	КопироватьДанныеФормы(ДанныеФормы, Форма.Объект);
	Форма.Открыть();
КонецПроцедуры

&НаСервере
Функция ЗаполнитьДокументПоступленияНаСервере(ДанныеФормы,ДопПараметры);
	Док = ДанныеФормыВЗначение(ДанныеФормы, Тип("ДокументОбъект.УЧ_ПоступлениеТоваров"));
	Док.Заполнить(ДопПараметры.ДанныеЗаполнения);
	
	ОрганизацияПродажи = Справочники.сабМониторВнедрения.НайтиПоНаименованию("ОрганизацияПродажи", Истина).Значение;
	СкладПродажи = Справочники.сабМониторВнедрения.НайтиПоНаименованию("СкладПродажи", Истина).Значение;
	
	Док.Организация = ДопПараметры.ДанныеЗаполнения.Организация;
	Док.Склад = ДопПараметры.ДанныеЗаполнения.Склад;
	
	СтруктураОтбора = Новый Структура;
  СтруктураОтбора.Вставить("Организация", Док.Организация);
  СтруктураРесурсов = РегистрыСведений.сабСоответствияОрганизацийПредприятиям.Получить(СтруктураОтбора);
	Док.Предприятие = СтруктураРесурсов.Предприятие;
	
	РеквизитОрганизация = ОрганизацияПродажи;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Контрагенты.Ссылка КАК Контрагент
	               |ИЗ
	               |	Справочник.Контрагенты КАК Контрагенты
	               |ГДЕ
	               |	Контрагенты.ИНН = &ИНН
	               |	И Контрагенты.КПП = &КПП";
	
	Запрос.УстановитьПараметр("ИНН", РеквизитОрганизация.ИНН);
	Запрос.УстановитьПараметр("КПП", РеквизитОрганизация.КПП);

	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Док.Контрагент = Выборка.Контрагент;
	КонецЦикла;

	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДоговорыКонтрагентов.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеДоговорыКонтрагента КАК ОсновныеДоговорыКонтрагента
		|		ПО ОсновныеДоговорыКонтрагента.Договор.Ссылка = ДоговорыКонтрагентов.Ссылка
		|ГДЕ
		|	ДоговорыКонтрагентов.Владелец = &Владелец
		|	И ДоговорыКонтрагентов.Организация = &Организация
		|	И НЕ ОсновныеДоговорыКонтрагента.Договор ЕСТЬ NULL";
	
	//Запрос.УстановитьПараметр("ВидДоговора", Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком);
	Запрос.УстановитьПараметр("Владелец", Док.Контрагент);
	Запрос.УстановитьПараметр("Организация", Док.Организация);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Док.Договор = ВыборкаДетальныеЗаписи.Ссылка;
	КонецЦикла;
	
	Док.ВидОперации = Перечисления.ВидыПоступлений.Поступление;
	
	
	
	//Док.Договор = Справочники.ДоговорыКонтрагентов.НайтиПоРеквизиту("Организация",Док.Организация,,Док.Контрагент); 
	
	ЗначениеВДанныеФормы(Док,ДанныеФормы);
КонецФункции