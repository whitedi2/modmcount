﻿#Область ОбщегоНазначения

// Функция формирует наименование с учетом свойств.
//
&НаКлиенте
Процедура  СформироватьАвтоНаименование()
	
	Элементы.Наименование.СписокВыбора.Очистить();
	
	ИспользоватьСвойства = ПолучитьФункциональнуюОпциюФормы("ИспользоватьДополнительныеРеквизитыИСведения");
	
	СтрокаНаименования = "";
	Если ИспользоватьСвойства Тогда
		
		НомерСвойства = 0;
		Для Каждого ДополнительноеСвойство Из ЭтаФорма.Свойства_ОписаниеДополнительныхРеквизитов Цикл
			ЗначениеСвойства = ЭтаФорма[ДополнительноеСвойство.ИмяРеквизитаЗначение];
			Если ЗначениеЗаполнено(ЗначениеСвойства) Тогда
				НомерСвойства = НомерСвойства + 1;
				СтрокаНаименования = СтрокаНаименования + ?(НомерСвойства = 1,"", ", ") + ЗначениеСвойства;
			КонецЕсли;
		КонецЦикла;
		
		Если ЗначениеЗаполнено(СтрокаНаименования) Тогда
			Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокаНаименования = "";
	Если ИспользоватьСвойства Тогда
		
		НомерСвойства = 0;
		Для Каждого ДополнительноеСвойство Из ЭтаФорма.Свойства_ОписаниеДополнительныхРеквизитов Цикл
			ЗначениеСвойства = ЭтаФорма[ДополнительноеСвойство.ИмяРеквизитаЗначение];
			
			Если ЗначениеЗаполнено(ДополнительноеСвойство.Наименование) Тогда
				НаименованиеСвойства = ДополнительноеСвойство.Наименование;
			Иначе
				НаименованиеСвойства = Строка(ДополнительноеСвойство.Свойство);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ЗначениеСвойства) Тогда
				НомерСвойства = НомерСвойства + 1;
				СтрокаНаименования = СтрокаНаименования + ?(НомерСвойства = 1,"", ", ") 
									 + НаименованиеСвойства +": "+ ЗначениеСвойства;
			КонецЕсли;
		КонецЦикла;
		
		Если ЗначениеЗаполнено(СтрокаНаименования) Тогда
			Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // СформироватьАвтоНаименование()

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Процедура - обработчик события "ПриСозданииНаСервере" формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки".
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	Элементы.ДекорацияПредупреждение.Видимость =  (ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.ВидыНоменклатуры"));
	
	Для Каждого НаборДопРеквизитов Из Элементы["ГруппаДополнительныеРеквизиты"].ПодчиненныеЭлементы Цикл
		
		Если ТипЗнч(НаборДопРеквизитов) = Тип("ГруппаФормы") Тогда
			
			Для Каждого ПодчиненныйЭлемент Из НаборДопРеквизитов.ПодчиненныеЭлементы Цикл
				
				Если ТипЗнч(ПодчиненныйЭлемент) = Тип("ПолеФормы") Тогда
					ПодчиненныйЭлемент.УстановитьДействие("ПриИзменении", "ДопРеквизитПриИзменении");
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	СформироватьАвтоНаименование()
	
КонецПроцедуры

&НаКлиенте
Процедура ДопРеквизитПриИзменении()

	СформироватьАвтоНаименование()

КонецПроцедуры // ДопРеквизитПриИзменении()

// Процедура - обработчик события "ОбработкаОповещения" формы.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

// Процедура - обработчик события "ПередЗаписьюНаСервере" формы.
//
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыПодсистемыСвойств

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, Объект.Ссылка);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.Свойства

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#КонецОбласти
