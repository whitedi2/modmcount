﻿
&НаКлиенте
Процедура ПредприятиеПриИзменении(Элемент)
	УчетПоПодразделениям = БюджетныйНаСервере.ВернутьРеквизит(Объект.Предприятие, "УчетПоПодразделениям");
//	Если НЕ Объект.ВидДокумента = "Заявка на согласование договора" Тогда
//		
////		Элементы.Подразделение1.Доступность = УчетПоПодразделениям;
//		
//	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДДСПриИзменении(Элемент)
	
	Объект.Наименование = "" + ?(Объект.Предприятие.Пустая(), "По всем предприятиям", Объект.Предприятие) + "; " + Объект.СтатьяДДС;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДокументаПриИзменении(Элемент)
	
	УстановитьВидимость();	
	ТипАвтомаршрутаПриИзменении(Неопределено);	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	СтрВидов = ПолучитьСтруктуруВидаДока(Объект.ВидДокумента);
	
	Элементы.ГруппаЗаявкаНаОплату.Видимость 					= СтрВидов.ЭтоЗаявкаНаФинансирование ИЛИ СтрВидов.ЭтоЗаявкаНаОплату;
	Элементы.МаршрутЗаявкиДопУсловия.Видимость 					= СтрВидов.ЭтоЗаявкаНаФинансирование ИЛИ СтрВидов.ЭтоЗаявкаНаОплату;
	Элементы.ГруппаСогласованиеДоговораСтроительство.Видимость 	= (СтрВидов.ЭтоЗаявкаНаСогласованиеДоговора ИЛИ Объект.ВидДокумента = "Согласование договора (строительство-тендер)");
	//Элементы.ТипАвтомаршрута.Видимость 							= (СтрВидов.ЭтоЗаявкаНаСогласованиеДоговора ИЛИ Объект.ВидДокумента = "Согласование договора (строительство-тендер)") ИЛИ СтрВидов.ЭтоЗаявкаНаОплату  ИЛИ Объект.ВидДокумента = "Карта сделки" ИЛИ Объект.ВидДокумента = "Заявка на согласование договора по проведению ТММ";
	
	Если НЕ Элементы.ТипАвтомаршрута.Видимость Тогда
		Объект.ТипАвтомаршрута = "Плоский";
	КонецЕсли;
	
	Элементы.ГруппаЗаявкиНаОтгрузку.Видимость 					= (СтрВидов.ЭтоЗаявкаНаОтгрузку);
	Элементы.ГруппаБюджетов.Видимость 							= (Объект.ВидДокумента = "Бюджет");
	Элементы.ГруппаИсполнение.Видимость 						= (СтрВидов.ЭтоЗаявкаНаОтгрузку ИЛИ СтрВидов.ЭтоЗаявкаНаОплату ИЛИ СтрВидов.ЭтоЗаявкаНаКадровоеДвижение ИЛИ СтрВидов.ЭтоЗаявкаНаФинансирование);
	Элементы.ГруппаОзнакомление.Видимость 						= (СтрВидов.ЭтоЗаявкаНаОтгрузку  ИЛИ СтрВидов.ЭтоЗаявкаНаКадровоеДвижение ИЛИ СтрВидов.ЭтоЗаявкаНаКорректировкуБюджета 
																	ИЛИ СтрВидов.ЭтоЗаявкаНаСогласованиеДоговора ИЛИ СтрВидов.ЭтоЗаявкаНаОплату ИЛИ Объект.ВидДокумента = "Согласование договора (строительство-тендер)" ИЛИ Объект.ВидДокумента = "Бюджет" ИЛИ Объект.ВидДокумента = "Бюджет оперативный" ИЛИ СтрВидов.ЭтоЗаявкаНаФинансирование);
	ВидимостьПодотчет();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСтруктуруВидаДока(ВидДокумента)

	//супербобики д1 16.11.17
	Стру = Новый Структура;
	Попытка
		ЭтоЗаявкаНаОплату = ВидДокумента = Справочники.Д_ВидыВнутреннихДокументов.ЗаявкаНаОплату;
	Исключение
		ЭтоЗаявкаНаОплату = Ложь;
	КонецПопытки;
	Стру.Вставить("ЭтоЗаявкаНаОплату", ЭтоЗаявкаНаОплату);
	Попытка
		ЭтоЗаявкаНаФинансирование = ВидДокумента = Справочники.Д_ВидыВнутреннихДокументов.ЗаявкаНаФинансирование;
	Исключение
		ЭтоЗаявкаНаФинансирование = Ложь;
	КонецПопытки;
	Стру.Вставить("ЭтоЗаявкаНаФинансирование", ЭтоЗаявкаНаФинансирование);
	Попытка
		ЭтоЗаявкаНаСогласованиеДоговора = ВидДокумента = Справочники.Д_ВидыВнутреннихДокументов.ЗаявкаНаСогласованиеДоговора;
	Исключение
		ЭтоЗаявкаНаСогласованиеДоговора = Ложь;
	КонецПопытки;
	Стру.Вставить("ЭтоЗаявкаНаСогласованиеДоговора", ЭтоЗаявкаНаСогласованиеДоговора);
	Попытка
		ЭтоЗаявкаНаКадровоеДвижение = ВидДокумента = Справочники.Д_ВидыВнутреннихДокументов.ЗаявкаНаКадровоеДвижение;
	Исключение
		ЭтоЗаявкаНаКадровоеДвижение = Ложь;
	КонецПопытки;
	Стру.Вставить("ЭтоЗаявкаНаКадровоеДвижение", ЭтоЗаявкаНаКадровоеДвижение);
	Попытка
		ЭтоЗаявкаНаКорректировкуБюджета = ВидДокумента = Справочники.Д_ВидыВнутреннихДокументов.КорректировкаБюджета;
	Исключение
		ЭтоЗаявкаНаКорректировкуБюджета = Ложь;
	КонецПопытки;
	Стру.Вставить("ЭтоЗаявкаНаКорректировкуБюджета", ЭтоЗаявкаНаКорректировкуБюджета);
	Попытка
		ЭтоЗаявкаНаОтгрузку = ВидДокумента = Справочники.Д_ВидыВнутреннихДокументов.ЗаявкаНаОтгрузку;
	Исключение
		ЭтоЗаявкаНаОтгрузку = Ложь;
	КонецПопытки;
	Стру.Вставить("ЭтоЗаявкаНаОтгрузку", ЭтоЗаявкаНаОтгрузку);
	
	Возврат Стру;
	//конец супербобику
	

КонецФункции // ()


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьТипамиДокументов();
	
	УстановитьВидимость();
	
	ВывестиПредприятияПодразделения();
		
	Для Каждого Строка Из Объект.ДопУсловия Цикл
		ТаблицаДопУсловийОбъекта = БПСервер.РаспаковатьТекстXML(Строка.Условие);
		Для Каждого СтрокаДопУсловийОбъекта Из ТаблицаДопУсловийОбъекта Цикл
			ЗаполнитьЗначенияСвойств(ДопУсловия.Добавить(), СтрокаДопУсловийОбъекта);
		КонецЦикла;
	КонецЦикла;
	
	///для формирования дерева маршрута
	сабБПКлиентСервер.ДобавитьДеревоМаршрута(Элементы, Команды, ТекущаяСтрокаГруппы, МаршрутДерево, Объект, УсловноеОформление, Новый Структура("ВремяНаВыполнение, Обязателен, МожетРедактировать", Истина, Истина, Истина));
	
	БюджетныйНаСервере.ДействияПриСозданииФормыСправочника(ЭтаФорма);
	
	
	//Если НЕ БюджетныйНаСервере.РольАдминаДоступнаСервер() Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВидыАвтомаршрутизацииПользователя.ВидАвтомаршрута
		|ИЗ
		|	РегистрСведений.ВидыАвтомаршрутизацииПользователя КАК ВидыАвтомаршрутизацииПользователя
		|ГДЕ
		|	ВидыАвтомаршрутизацииПользователя.Пользователь = &Пользователь";
		Запрос.УстановитьПараметр("Пользователь", ПараметрыСеанса.ТекущийПользователь);
		
		РезультатЗапроса = Запрос.Выполнить();
		Если Не РезультатЗапроса.Пустой() Тогда
			Элементы.ВидДокумента.СписокВыбора.Очистить();
			Выборка = РезультатЗапроса.Выбрать();
			Пока Выборка.Следующий() Цикл
				Элементы.ВидДокумента.СписокВыбора.Добавить(Выборка.ВидАвтомаршрута, Выборка.ВидАвтомаршрута);
			КонецЦикла;
		КонецЕсли;	
		
	//КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТипамиДокументов()
	
	СтруктураДоков = БПСервер.СписокВидовСЗ(Неопределено, "Все документы");
	
	ИндексКоманды = 0;
	Для Каждого ВидОперации Из СтруктураДоков Цикл
		Если ТипЗнч(ВидОперации.Ссылка) = Тип("СправочникСсылка.Д_ВидыВнутреннихДокументов") И НЕ ВидОперации.ЭтоРодитель Тогда
			Элементы.ВидДокумента.СписокВыбора.Добавить(ВидОперации.Ссылка);					
		КонецЕсли;
	КонецЦикла;
	
	//Если Элементы.ВидДокумента.СписокВыбора.НайтиПоЗначению(Справочники.Д_ВидыВнутреннихДокументов.Произвольная) = Неопределено Тогда
	//	Элементы.ВидДокумента.СписокВыбора.Добавить(Справочники.Д_ВидыВнутреннихДокументов.Произвольная);	
	//КонецЕсли;
	
	//Элементы.ВидДокумента.СписокВыбора.Добавить("Реестр заявок на оплату", "Реестр заявок на оплату"); 
	//Элементы.ВидДокумента.СписокВыбора.Добавить("Заявка на оплату", "Заявка на оплату");
	//Элементы.ВидДокумента.СписокВыбора.Добавить("Заявка на согласование договора", "Заявка на согласование договора");
	//Элементы.ВидДокумента.СписокВыбора.Добавить("Внутренний документ", "Внутренний документ");
	//Элементы.ВидДокумента.СписокВыбора.Добавить("Заявка на отгрузку", "Заявка на отгрузку");
	//Элементы.ВидДокумента.СписокВыбора.Добавить("Заявка на кадровое движение", "Заявка на кадровое движение");
	//Если Константы.сабИспользоватьПодсистемуБюджетирование.Получить() Тогда
	Элементы.ВидДокумента.СписокВыбора.Добавить("Заявка на корректировку текущего бюджета", "Заявка на корректировку текущего бюджета");
	Элементы.ВидДокумента.СписокВыбора.Добавить("Бюджет оперативный", "Бюджет оперативный");
	Элементы.ВидДокумента.СписокВыбора.Добавить("Бюджет", "Бюджет");
	//КонецЕсли;
	//Элементы.ВидДокумента.СписокВыбора.Добавить("Заявка на торговлю", "Заявка на торговлю");
	//Элементы.ВидДокумента.СписокВыбора.Добавить("Карта сделки", "Карта сделки");
	//Элементы.ВидДокумента.СписокВыбора.Добавить("Заявка на согласование договора по проведению ТММ", "Заявка на согласование договора по проведению ТММ");
	//Элементы.ВидДокумента.СписокВыбора.Добавить("Заявка на согласование договора по оплате РБ(Премии)", "Заявка на согласование договора по оплате РБ(Премии)");
	Элементы.ВидДокумента.СписокВыбора.Добавить("Согласование отпуска", "Согласование отпуска");
 	
 
 КонецПроцедуры
 

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не ЗначениеЗаполнено(Объект.ТипАвтомаршрута) Тогда
		Объект.ТипАвтомаршрута = "Простой";	
	КонецЕсли;
	
	СтруВидов = ПолучитьСтруктуруВидаДока(Объект.ВидДокумента);
	
	Если СтруВидов.ЭтоЗаявкаНаОплату ИЛИ СтруВидов.ЭтоЗаявкаНаФинансирование Тогда
		Если Объект.Предприятие.Пустая() И Объект.СтатьяДДС.Пустая() И Объект.Подразделение.Пустая() Тогда
			Объект.Наименование = "Универсальный";
		Иначе	
			Объект.Наименование = "" + ?(Объект.Предприятие.Пустая(), "По всем предприятиям", Строка(Объект.Предприятие)) + "; " + ?(Объект.Подразделение.Пустая(), "По всем поразделениям", Объект.Подразделение) + "; " 
									+ ?(Объект.СтатьяДДС.Пустая(), "По всем статьям", Объект.СтатьяДДС) + "; " + Объект.ТипПлатежа + "; " + ?(Объект.ВыдачаВПодОтчет = 0, "", ?(Объект.ВыдачаВПодОтчет = 1, "В подотчет", "Не в подотчет"));
		КонецЕсли;
		СформироватьСтрокуИнформации();
	ИначеЕсли СтруВидов.ЭтоЗаявкаНаОтгрузку Тогда	
		Объект.Наименование = "" + ?(Объект.Предприятие.Пустая(), "По всем предприятиям", " " + Строка(Объект.Предприятие)) + "; " + ?(НЕ ЗначениеЗаполнено(Объект.ТипРеализации), "По всем типам реализации", Объект.ТипРеализации);
	ИначеЕсли СтруВидов.ЭтоЗаявкаНаСогласованиеДоговора Или Объект.ВидДокумента = "Согласование договора (строительство-тендер)" Тогда	
		Объект.Наименование = ?(Объект.Служба.Пустая(), Объект.ВидДокумента, Объект.Служба);
	ИначеЕсли СтруВидов.ЭтоЗаявкаНаКадровоеДвижение Тогда	
		Объект.Наименование = Объект.ВидДокумента + ": " + ?(Объект.Предприятие.Пустая(), "По всем предприятиям", " " + Строка(Объект.Предприятие)) + "; " + ?(Объект.Подразделение.Пустая(), "По всем поразделениям", " " + Строка(Объект.Подразделение));	
	ИначеЕсли Объект.ВидДокумента = "Бюджет" Тогда	
		Объект.Наименование = "" + Объект.ВидДокумента + " " + Объект.ТипБюджета + ?(Объект.Предприятие.Пустая(), "; По всем предприятиям", " " + " " + Строка(Объект.Предприятие));	
	Иначе
		Объект.Наименование = "" + Объект.ВидДокумента + ?(Объект.Предприятие.Пустая(), "; По всем предприятиям", " " + Строка(Объект.Предприятие));
	КонецЕсли;
	
	//трансформируем дерево в ТЧ
	//Если Объект.ТипАвтомаршрута = "С группировками" Тогда
		Объект.МаршрутЗаявки.Очистить();//неоптимально, т.к. регистр изменений
		Объект.МаршрутИсполнения.Очистить();
		Объект.МаршрутОзнакомления.Очистить();
		ТекЭлементы = МаршрутДерево.ПолучитьЭлементы();
		Для каждого ТекЭлемент Из ТекЭлементы Цикл
			ДобавитьУровеньНаЗапись(ТекЭлемент.ПолучитьЭлементы(), ТекЭлемент.Пользователь);	
		КонецЦикла;
	//КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДозаполнитьРолиСогласователей(ТекущийОбъект)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	РолиИсполнителей.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.РолиИсполнителей КАК РолиИсполнителей
	|ГДЕ
	|	РолиИсполнителей.РольПоУмолчанию = ИСТИНА";
	
	Запрос.УстановитьПараметр("", );
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Для каждого ТекСтрока Из ТекущийОбъект.МаршрутЗаявки Цикл
			Если Не ЗначениеЗаполнено(ТекСтрока.РольПользователя) Тогда
				ТекСтрока.РольПользователя = Выборка.Ссылка;
			КонецЕсли;
		КонецЦикла; 	
	КонецЦикла;
КонецПроцедуры


&НаКлиенте
Процедура ДобавитьУровеньНаЗапись(ТекЭлементы,  ТекТЧ)
	Для каждого ТекЭл Из ТекЭлементы Цикл
		Если ТекЭл.ПолучитьЭлементы().Количество() Тогда
			ДобавитьУровеньНаЗапись(ТекЭл.ПолучитьЭлементы(), ТекТЧ);	
		Иначе
			Если ТекТЧ = "Согласование" Тогда
				НоваяСтрока = Объект.МаршрутЗаявки.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекЭл);
				НоваяСтрока.СубъектСогласования = ТекЭл.Пользователь;
			ИначеЕсли ТекТЧ = "Исполнение" Тогда
				НоваяСтрока = Объект.МаршрутИсполнения.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекЭл);
				НоваяСтрока.Исполнитель = ТекЭл.Пользователь;
			Иначе
				НоваяСтрока = Объект.МаршрутОзнакомления.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекЭл);
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПредприятиеПриИзменении(Неопределено);
	Предприятие2ПриИзменении(Неопределено);
	МаршрутЗаявкиПослеУдаления(Неопределено);
	МаршрутОзнакомленияПослеУдаления(Неопределено);
	МаршрутИсполненияПослеУдаления(Неопределено);
	ТипАвтомаршрутаПриИзменении(Неопределено);
	
	Для Каждого СтрокаПредприятия Из ТаблицаПредприятий Цикл
		СформироватьСтрокуПредставленияПодразделений(СтрокаПредприятия);
	КонецЦикла;
	
	ОбновитьНадписиДопУсловий();
	
	//для формирования дерева маршрута
	сабБПКлиентСервер.РазвернутьГруппировкиДерева(Элементы, МаршрутДерево);

КонецПроцедуры

&НаКлиенте
Процедура Подразделение1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтруВидов = ПолучитьСтруктуруВидаДока(Объект.ВидДокумента);

	Если СтруВидов.ЭтоЗаявкаНаСогласованиеДоговора Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.СтруктураПредприятия.ФормаВыбора",,Элемент); 
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТипПлатежаПриИзменении(Элемент)
	
	ВидимостьПодотчет();
	СформироватьСтрокуИнформации();
	
КонецПроцедуры

&НаСервере
Процедура ВидимостьПодотчет()
	
	Элементы.ВыдачаПодотчет.Видимость = (Объект.ТипПлатежа = Перечисления.Д_ИсточникиСредств.Нал);	
	
КонецПроцедуры

&НаКлиенте
Процедура Предприятие2ПриИзменении(Элемент)
	УчетПоПодразделениям = БюджетныйНаСервере.ВернутьРеквизит(Объект.Предприятие, "УчетПоПодразделениям");
	Элементы.Подразделение.Доступность = УчетПоПодразделениям;
КонецПроцедуры

&НаКлиенте
Процедура МаршрутИсполненияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	КоличСтрок = Объект.МаршрутИсполнения.Количество();
	Элементы.ГруппаИсполнение.Заголовок = ?(КоличСтрок, "Исполнение (" + Строка(КоличСтрок) + ")", "Исполнение");
	
	УстановитьИдСтроки(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура МаршрутЗаявкиПослеУдаления(Элемент)
	
	КоличСтрок = Объект.МаршрутЗаявки.Количество();
	Элементы.ГруппаСогласование.Заголовок = ?(КоличСтрок, "Согласование (" + Строка(КоличСтрок) + ")", "Согласование");
	
КонецПроцедуры

&НаКлиенте
Процедура МаршрутЗаявкиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	КоличСтрок = Объект.МаршрутЗаявки.Количество();
	Элементы.ГруппаСогласование.Заголовок = ?(КоличСтрок, "Согласование (" + Строка(КоличСтрок) + ")", "Согласование");
	
	УстановитьИдСтроки(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура МаршрутИсполненияПослеУдаления(Элемент)
	КоличСтрок = Объект.МаршрутИсполнения.Количество();
	Элементы.ГруппаИсполнение.Заголовок = ?(КоличСтрок, "Исполнение (" + Строка(КоличСтрок) + ")", "Исполнение");
КонецПроцедуры

&НаКлиенте
Процедура МаршрутОзнакомленияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	КоличСтрок = Объект.МаршрутОзнакомления.Количество();
	Элементы.ГруппаОзнакомление.Заголовок = ?(КоличСтрок, "Ознакомление (" + Строка(КоличСтрок) + ")", "Ознакомление");
КонецПроцедуры

&НаКлиенте
Процедура МаршрутОзнакомленияПослеУдаления(Элемент)
	КоличСтрок = Объект.МаршрутОзнакомления.Количество();
	Элементы.ГруппаОзнакомление.Заголовок = ?(КоличСтрок, "Ознакомление (" + Строка(КоличСтрок) + ")", "Ознакомление");
КонецПроцедуры

&НаКлиенте
Процедура ПредприятияПодразделенияПриИзменении(Элемент)
	
	СформироватьСтрокуИнформации();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьиДДСПриИзменении(Элемент)
	
	СформироватьСтрокуИнформации();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыдачаПодотчетПриИзменении(Элемент)
	
	СформироватьСтрокуИнформации();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьСтрокуИнформации()
	
	Информация = "";
	Если ТаблицаПредприятий.Количество() = 0 Тогда
		Информация = Информация + "По всем предприятиям; ";
	Иначе
		Для Каждого СтрокаПредприятия Из ТаблицаПредприятий Цикл
			Информация = Информация + СтрокаПредприятия.Предприятие;	
			КоличествоЗаходов = 0;
			Для Каждого ПодразделениеСписка Из СтрокаПредприятия.СписокПодразделений Цикл
				Если ЗначениеЗаполнено(ПодразделениеСписка.Значение) Тогда
					КоличествоЗаходов = КоличествоЗаходов + 1;
					Если КоличествоЗаходов = 1 Тогда
						Информация = Информация + " (";
					КонецЕсли;	
					Если КоличествоЗаходов > 1 Тогда
						Информация = Информация + ", ";
					КонецЕсли;
					Информация = Информация + ПодразделениеСписка.Значение;
				КонецЕсли;	
			КонецЦикла;
			Если КоличествоЗаходов > 0 Тогда
				Информация = Информация + ")";
			КонецЕсли;	
			Информация = Информация + "; ";
		КонецЦикла;
	КонецЕсли;
	
	Если Объект.СтатьиДДС.Количество() = 0 Тогда
		Информация = Информация + "По всем статьям; ";
	Иначе
		Для Каждого СтрокаДДС Из Объект.СтатьиДДС Цикл
			Информация = Информация + СтрокаДДС.СтатьяДДС + "; ";
		КонецЦикла;	
	КонецЕсли;
	
	Информация = Информация + Объект.ТипПлатежа + "; " + ?(Объект.ВыдачаВПодОтчет = 0, "", ?(Объект.ВыдачаВПодОтчет = 1, "В подотчет", "Не в подотчет"));
	
	Объект.Наименование = Информация;
	
КонецПроцедуры	

&НаКлиенте
Процедура ТаблицаПредприятийПодразделениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.ТаблицаПредприятий.ТекущиеДанные = Неопределено Тогда
		Возврат;
	ИначеЕсли Не ЗначениеЗаполнено(Элементы.ТаблицаПредприятий.ТекущиеДанные.Предприятие) Тогда
		Возврат;
	ИначеЕсли Не БюджетныйНаСервере.ВернутьРеквизит(Элементы.ТаблицаПредприятий.ТекущиеДанные.Предприятие, "УчетПоПодразделениям") Тогда
		Возврат;
	КонецЕсли;	
	
	СписокПодразделений = Элементы.ТаблицаПредприятий.ТекущиеДанные.СписокПодразделений;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА СтруктураПредприятия.Ссылка В (&СписокПодразделений)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЗначениеВыбрано,
	|	СтруктураПредприятия.Ссылка КАК Подразделение
	|ИЗ
	|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|ГДЕ
	|	СтруктураПредприятия.Владелец = &Владелец";
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Владелец", Элементы.ТаблицаПредприятий.ТекущиеДанные.Предприятие);
	СтруктураПараметров.Вставить("СписокПодразделений", СписокПодразделений);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СтруктураПараметров", СтруктураПараметров);
	ПараметрыФормы.Вставить("ТекстЗапроса", ТекстЗапроса);
	ПараметрыФормы.Вставить("МножественныйВыбор", Истина);
	
	МассивПодразделений = ОткрытьФормуМодально("ОбщаяФорма.УниверсальнаяФормаВыбора", ПараметрыФормы);
	
	СписокПодразделений.Очистить();
	
	Если Не МассивПодразделений = Неопределено Тогда
		Для Каждого ВыбраннаяСтрока Из МассивПодразделений Цикл
			СписокПодразделений.Добавить(ВыбраннаяСтрока.Подразделение);
		КонецЦикла;	
		СформироватьСтрокуПредставленияПодразделений(Элементы.ТаблицаПредприятий.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьСтрокуПредставленияПодразделений(ТекДанные)

	СтрокаПодразделений = "";
	Для Каждого ПодразделениеСписка Из ТекДанные.СписокПодразделений Цикл
		Если ЗначениеЗаполнено(ПодразделениеСписка.Значение) Тогда
			СтрокаПодразделений = СтрокаПодразделений + ПодразделениеСписка.Значение + "; ";
		КонецЕсли;
	КонецЦикла;	
	
	ТекДанные.ПредставлениеПодразделения = СтрокаПодразделений;
	
КонецПроцедуры	

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ПредприятияПодразделения.Очистить();
	
	Для Каждого СтрокаПредприятий Из ТаблицаПредприятий Цикл
		Если СтрокаПредприятий.СписокПодразделений.Количество() = 0 Тогда
			СтрокаПредприятийПодразделений = ТекущийОбъект.ПредприятияПодразделения.Добавить();
			СтрокаПредприятийПодразделений.Предприятие = СтрокаПредприятий.Предприятие;
		КонецЕсли;	
		Для Каждого СтрокаПодразделений Из СтрокаПредприятий.СписокПодразделений Цикл 
			СтрокаПредприятийПодразделений = ТекущийОбъект.ПредприятияПодразделения.Добавить();
			СтрокаПредприятийПодразделений.Предприятие = СтрокаПредприятий.Предприятие;
			СтрокаПредприятийПодразделений.Подразделение = СтрокаПодразделений.Значение;
		КонецЦикла;	
	КонецЦикла;
	
	СтрокаПредприятийПодразделений = ТекущийОбъект.ПредприятияПодразделения.Добавить();
	СтрокаПредприятийПодразделений.Предприятие = Объект.Предприятие;
	СтрокаПредприятийПодразделений.Подразделение = Объект.Подразделение;
	
	ТаблицаДопУсловий = РеквизитФормыВЗначение("ДопУсловия");
	ТекущийОбъект.ДопУсловия.Очистить();
	
	ТаблицаСтрокМаршрута = Новый ТаблицаЗначений;
	ТаблицаСтрокМаршрута.Колонки.Добавить("ИДСтроки", Новый ОписаниеТипов("УникальныйИдентификатор"));
	
	Для Каждого СтрокаМаршрута Из ТекущийОбъект.МаршрутЗаявки Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаСтрокМаршрута.Добавить(), СтрокаМаршрута);
	КонецЦикла;	
	
	Для Каждого СтрокаМаршрута Из ТекущийОбъект.МаршрутИсполнения Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаСтрокМаршрута.Добавить(), СтрокаМаршрута);
	КонецЦикла;	
	
	Для Каждого СтрокаУсловий Из ТаблицаСтрокМаршрута Цикл
		СтрокаДопУсловийОбъекта = ТекущийОбъект.ДопУсловия.Добавить();
		СтрокаДопУсловийОбъекта.ИУДСтрокиВладельца = СтрокаУсловий.ИДСтроки;
		//найдем строки с гуидом нашей строки
		МассивСтрок = ТаблицаДопУсловий.НайтиСтроки(Новый Структура("ИДСтроки", СтрокаУсловий.ИДСтроки));
        НоваяТаблицаУсловий = ТаблицаДопУсловий.Скопировать(МассивСтрок); 
		СтрокаДопУсловийОбъекта.Условие = БПСервер.УпаковатьТекстXML(НоваяТаблицаУсловий);
	КонецЦикла;
	
	ДозаполнитьРолиСогласователей(ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ВывестиПредприятияПодразделения()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВходящиеДанные.Предприятие,
	|	ВходящиеДанные.Подразделение
	|ПОМЕСТИТЬ ВТ_Данные
	|ИЗ
	|	&ВходящиеДанные КАК ВходящиеДанные
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Данные.Предприятие КАК Предприятие,
	|	ВТ_Данные.Подразделение
	|ИЗ
	|	ВТ_Данные КАК ВТ_Данные
	|ИТОГИ ПО
	|	Предприятие";
	Запрос.УстановитьПараметр("ВходящиеДанные", Объект.ПредприятияПодразделения.Выгрузить());
	
	ВыборкаПредприятия = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПредприятия.Следующий() Цикл
		ВыборкаПодразделения = ВыборкаПредприятия.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		СтрокаТаблицы = ТаблицаПредприятий.Добавить();
		СтрокаТаблицы.Предприятие = ВыборкаПредприятия.Предприятие;  
		Пока ВыборкаПодразделения.Следующий() Цикл
			СтрокаТаблицы.СписокПодразделений.Добавить(ВыборкаПодразделения.Подразделение);  
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры	

&НаКлиенте
Процедура ТаблицаПредприятийПриИзменении(Элемент)
	
	СформироватьСтрокуИнформации();
	
КонецПроцедуры

&НаКлиенте
Процедура МаршрутЗаявкиДопУсловияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьФормуМодально("Справочник.МаршрутыДвиженияЗаявок.Форма.ФормаДопУсловий", Новый Структура("ИД", Элемент.Родитель.ТекущиеДанные.ИДСтроки), ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура МаршрутЗаявкиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	УстановитьИДСтроки(Элемент, НоваяСтрока)
		
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьНадписиДопУсловий()
	
	//Согласование
	Для Каждого СтрокаМаршрута ИЗ Объект.МаршрутЗаявки Цикл
		СтрокаМаршрута.ДопУсловия = "";
	КонецЦикла;	
	
	Для Каждого СтрокаУсловий Из ДопУсловия Цикл
		НайденныеСтроки = Объект.МаршрутЗаявки.НайтиСтроки(Новый Структура("ИДСтроки", СтрокаУсловий.ИДСтроки));
		Для Каждого СтрокаДопУсловийВладельца Из НайденныеСтроки Цикл
			СтрокаПредставления = СтрокаДопУсловийВладельца.ДопУсловия;
			СтрокаДопУсловийВладельца.ДопУсловия = СтрокаПредставления + ?(ЗначениеЗаполнено(СтрокаПредставления), "; ", "") + СтрокаУсловий.Реквизит + " " + СтрокаУсловий.ВидСравнения + " " + СтрокаУсловий.Значение;
		КонецЦикла;	
	КонецЦикла;
	
	//Исполнение
	Для Каждого СтрокаМаршрута ИЗ Объект.МаршрутИсполнения Цикл
		СтрокаМаршрута.ДопУсловия = "";
	КонецЦикла;	
	
	Для Каждого СтрокаУсловий Из ДопУсловия Цикл
		НайденныеСтроки = Объект.МаршрутИсполнения.НайтиСтроки(Новый Структура("ИДСтроки", СтрокаУсловий.ИДСтроки));
		Для Каждого СтрокаДопУсловийВладельца Из НайденныеСтроки Цикл
			СтрокаПредставления = СтрокаДопУсловийВладельца.ДопУсловия;
			СтрокаДопУсловийВладельца.ДопУсловия = СтрокаПредставления + ?(ЗначениеЗаполнено(СтрокаПредставления), "; ", "") + СтрокаУсловий.Реквизит + " " + СтрокаУсловий.ВидСравнения + " " + СтрокаУсловий.Значение;
		КонецЦикла;	
	КонецЦикла;
	
	//опрашиваем дерево маршрута
	ТекЭлементы = МаршрутДерево.ПолучитьЭлементы();
	Для каждого ТекЭлемент Из ТекЭлементы Цикл
		ДобавитьУровеньДляПредставленияДопУсловий(ТекЭлемент.ПолучитьЭлементы(), ТекЭлемент.Пользователь);	
	КонецЦикла; 

	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьУровеньДляПредставленияДопУсловий(ТекЭлементы, ТекТЧ)
	Для каждого ТекЭл Из ТекЭлементы Цикл
		Если ТекЭл.ПолучитьЭлементы().Количество() Тогда
			ДобавитьУровеньДляПредставленияДопУсловий(ТекЭл.ПолучитьЭлементы(), ТекТЧ);	
		Иначе
			СтрокаПредставления = "";
			Для Каждого СтрокаУсловий Из ДопУсловия Цикл
				Если ТекЭл.ИдСтроки = СтрокаУсловий.ИдСтроки Тогда
					СтрокаПредставления = СтрокаПредставления + ?(ЗначениеЗаполнено(СтрокаПредставления), "; ", "") + СтрокаУсловий.Реквизит + " " + СтрокаУсловий.ВидСравнения + " " + СтрокаУсловий.Значение;
				КонецЕсли;
			КонецЦикла;
			ТекЭл.ДопУсловия = СтрокаПредставления;
		КонецЕсли;	
	КонецЦикла;
КонецПроцедуры



&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьНадписиДопУсловий" Тогда
		ОбновитьНадписиДопУсловий();	
	КонецЕсли;	
		
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
		ОбновитьНадписиДопУсловий();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИдСтроки(Элемент, НоваяСтрока = Ложь)
	
	ТекДанные = Элемент.ТекущиеДанные;
	
	Если НоваяСтрока Тогда
		ТекДанные.ИДСтроки = Новый УникальныйИдентификатор;
		ТекДанные.ДопУсловия = "";
	Иначе
		Если Не ТекДанные = Неопределено Тогда
			Если НЕ ЗначениеЗаполнено(ТекДанные.ИдСтроки) Тогда
				ТекДанные.ИДСтроки = Новый УникальныйИдентификатор;
			КонецЕсли;
		КонецЕсли;	
	КонецЕсли;

КонецПроцедуры	

&НаКлиенте
Процедура МаршрутИсполненияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	УстановитьИДСтроки(Элемент, НоваяСтрока)
	
КонецПроцедуры

&НаКлиенте
Процедура МаршрутИсполненияДопУсловияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьФормуМодально("Справочник.МаршрутыДвиженияЗаявок.Форма.ФормаДопУсловий", Новый Структура("ИД", Элементы.МаршрутИсполнения.ТекущиеДанные.ИДСтроки), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипАвтомаршрутаПриИзменении(Элемент)
	Элементы.ГруппаСогласование.Видимость = Ложь;
	Элементы.ГруппаИсполнение.Видимость = Ложь;
	Элементы.ГруппаОзнакомление.Видимость = Ложь;
	//Элементы.НовыйВидМаршрута.Видимость = (Объект.ТипАвтомаршрута = "С группировками");
	Элементы.НовыйВидМаршрута.Видимость = Истина;
	Элементы.Группа1.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
КонецПроцедуры



///////////////////////////////генерирование дерева маршрутов///////////////////////
#Область ГенерированиеДереваМаршрутов
	
&НаКлиенте
Процедура Реквизит1ПередНачаломИзменения(Элемент, Отказ)
	Если Элемент.ТекущиеДанные.Пользователь = "Согласование" ИЛИ Элемент.ТекущиеДанные.Пользователь = "Исполнение" ИЛИ Элемент.ТекущиеДанные.Пользователь = "Ознакомление" Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	Если Элемент.ТекущиеДанные.Пользователь = "Группа И" ИЛИ Элемент.ТекущиеДанные.Пользователь = "Группа ИЛИ" Тогда
		Массив = Новый Массив;
		Массив.Добавить(Тип("Строка"));
		ОписаниеТиповС = Новый ОписаниеТипов(Массив);
		Элементы.Колонка1.ОграничениеТипа = ОписаниеТиповС;
		
		Элементы.Колонка1.РежимВыбораИзСписка = Истина;
		ТекСписок = Новый СписокЗначений;
		Элементы.Колонка1.СписокВыбора.Добавить("Группа И");
		Элементы.Колонка1.СписокВыбора.Добавить("Группа ИЛИ");
	КонецЕсли;
	//Элементы.Колонка1.ВыбиратьТип = Ложь;
	//Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Пользователь) Тогда
	//	Элемент.ТекущиеДанные.Пользователь = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Реквизит1ПриАктивизацииСтроки(Элемент)
	Если НЕ Элемент.ТекущиеДанные = Неопределено Тогда
		Если ТипЗнч(Элемент.ТекущиеДанные.Пользователь) = Тип("Строка") Тогда
			ТекущаяСтрокаГруппы = Элемент.ТекущиеДанные.ИдГруппы;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Реквизит1ПередУдалением(Элемент, Отказ)
	Если Элемент.ТекущиеДанные.Пользователь = "Согласование" ИЛИ Элемент.ТекущиеДанные.Пользователь = "Исполнение" ИЛИ Элемент.ТекущиеДанные.Пользователь = "Ознакомление" Тогда
		Отказ = Истина;	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьГруппу(Команда)
	
	Элементы.Колонка1.СписокВыбора.Очистить();
	
	Массив = Новый Массив;
	Массив.Добавить(Тип("Строка"));
	ОписаниеТиповС = Новый ОписаниеТипов(Массив);
	Элементы.Колонка1.ОграничениеТипа = ОписаниеТиповС;

	
	Элементы.ТаблицаФормы123.ДобавитьСтроку();
	Элементы.Колонка1.РежимВыбораИзСписка = Истина;
	ТекСписок = Новый СписокЗначений;
	Элементы.Колонка1.СписокВыбора.Добавить("Группа И");
	Элементы.Колонка1.СписокВыбора.Добавить("Группа ИЛИ");
КонецПроцедуры

&НаКлиенте
Процедура Реквизит1ПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	Элементы.Колонка1.СписокВыбора.Очистить();
	Элементы.Колонка1.РежимВыбораИзСписка = Ложь;
	Если Элемент.ТекущиеДанные.Пользователь = "Группа И" ИЛИ Элемент.ТекущиеДанные.Пользователь = "Группа ИЛИ" Тогда
		Элемент.ТекущиеДанные.ЭтоГруппа = Истина;
		ТекущаяСтрокаГруппы = Новый УникальныйИдентификатор;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.ИДГруппы) Тогда
		Элемент.ТекущиеДанные.ИДГруппы = ТекущаяСтрокаГруппы;
	КонецЕсли;
	
	Массив = Новый Массив;
	Массив.Добавить(Тип("СправочникСсылка.Пользователи"));
	Массив.Добавить(Тип("СправочникСсылка.ГруппыПользователей"));
	Массив.Добавить(Тип("ПеречислениеСсылка.ОсновныеДолжностиПредприятия"));
	Массив.Добавить(Тип("СправочникСсылка.Д_Должности"));
	ОписаниеТиповС = Новый ОписаниеТипов(Массив);
	
	Элементы.Колонка1.ОграничениеТипа = ОписаниеТиповС;
	
	
	Уровень = 0;
	ТекЭлемент = Элемент.ТекущиеДанные.ПолучитьРодителя();
	Пока НЕ ТекЭлемент = Неопределено Цикл
		Уровень = Уровень + 1;
		ТекЭлемент = ТекЭлемент.ПолучитьРодителя();
	КонецЦикла;
	Элемент.ТекущиеДанные.Уровень = Уровень;
	
	Если Уровень = 1 Тогда
		Элемент.ТекущиеДанные.ТипГруппы = "Группа И";
	Иначе
		ТекРодитель = Элемент.ТекущиеДанные.ПолучитьРодителя();
		Если НЕ ТекРодитель = Неопределено Тогда
			Элемент.ТекущиеДанные.ТипГруппы = ТекРодитель.Пользователь;
		КонецЕсли;
	КонецЕсли;
	
	//работа с ТЧ
	УстановитьИдСтроки(Элемент);
	

КонецПроцедуры

&НаКлиенте
Процедура Реквизит1ПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если НЕ Копирование Тогда
		Если НЕ ТипЗнч(Элемент.ТекущиеДанные.Пользователь) =  Тип("Строка") Тогда
			Отказ = Истина;
			Элемент.ТекущаяСтрока = МаршрутДерево.НайтиПоИдентификатору(Элемент.ТекущаяСтрока).ПолучитьРодителя().ПолучитьИдентификатор();
			Элемент.ДобавитьСтроку();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Реквизит1ПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	УстановитьИДСтроки(Элемент, НоваяСтрока)
		
КонецПроцедуры

&НаКлиенте
Процедура Реквизит1ДопУсловияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьФормуМодально("Справочник.МаршрутыДвиженияЗаявок.Форма.ФормаДопУсловий", Новый Структура("ИД", Элемент.Родитель.ТекущиеДанные.ИДСтроки), ЭтаФорма);

КонецПроцедуры

&НаКлиенте                                                                     
Процедура Реквизит1Перетаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	а = 1;
	ЗначениеКуда = МаршрутДерево.НайтиПоИдентификатору(Строка);
	ЗначениеЧто = МаршрутДерево.НайтиПоИдентификатору(Элемент.ТекущаяСтрока);	
	Если НЕ ЗначениеКуда.ИдГруппы = Элемент.ТекущиеДанные.ИдГруппы Тогда
		Вставка = Ложь;
		Если НЕ ТипЗнч(ЗначениеКуда.Пользователь) = Тип("Строка") Тогда
			Вставка = Истина;
			Пока НЕ ТипЗнч(ЗначениеКуда.Пользователь) = Тип("Строка") Цикл
				ЗначениеКуда = ЗначениеКуда.ПолучитьРодителя();			
			КонецЦикла;		
		КонецЕсли;
		
		Элемент.ТекущиеДанные.ИдГруппы = ЗначениеКуда.ИдГруппы;
		Уровень = 1; //т.к. получаем родителя у группы
		ТекЭлемент = ЗначениеКуда.ПолучитьРодителя();
		Пока НЕ ТекЭлемент = Неопределено Цикл
			Уровень = Уровень + 1;
			ТекЭлемент = ТекЭлемент.ПолучитьРодителя();
		КонецЦикла;
		Элемент.ТекущиеДанные.Уровень = Уровень;
		
		Если Уровень = 1 Тогда
			Элемент.ТекущиеДанные.ТипГруппы = "Группа И";
		Иначе
			Элемент.ТекущиеДанные.ТипГруппы = ЗначениеКуда.Пользователь;
		КонецЕсли;
		
		ЭлементыКуда = ЗначениеКуда.ПолучитьЭлементы();
		//Если Вставка Тогда
		//	НовыйЭлемент = ЭлементыКуда.Вставить(МаршрутДерево.НайтиПоИдентификатору(Строка).ПолучитьИдентификатор());
		//Иначе
		НовыйЭлемент = ЭлементыКуда.Добавить();
		//КонецЕсли;
		ЗаполнитьЗначенияСвойств(НовыйЭлемент, Элемент.ТекущиеДанные);
		
		РодительЧто = ЗначениеЧто.ПолучитьРодителя();
		РодительЧто.ПолучитьЭлементы().Удалить(ЗначениеЧто);
		
	КонецЕсли;

	//Элемент.ТекущаяСтрока = Строка;                                              
	//Если НЕ ТипЗнч(Элемент.ТекущиеДанные.Пользователь) =  Тип("Строка") Тогда
	//	СтандартнаяОбработка = Ложь;
	//КонецЕсли;
КонецПроцедуры



#КонецОбласти 
