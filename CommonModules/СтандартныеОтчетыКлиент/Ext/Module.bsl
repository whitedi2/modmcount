﻿Процедура ДобавитьПоляРесурсовВЗапрещенныеПоля(Форма, СписокПолей) Экспорт
	
	Для Каждого ИмяПоказателя Из Форма.НаборПоказателей Цикл
		Если Форма.Отчет["Показатель" + ИмяПоказателя] Тогда 
			Если ИмяПоказателя = "Контроль" Тогда
				Продолжить;
			КонецЕсли;
			ВидОстатка = "";
			Если Форма.Отчет.Свойство("РазвернутоеСальдо") Тогда
				Если ТипЗнч(Форма.Отчет.РазвернутоеСальдо) = Тип("Булево") Тогда
					Если Форма.Отчет.РазвернутоеСальдо Тогда
						ВидОстатка = "";
					Иначе
						ВидОстатка = "Развернутый";
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			СписокПолей.Добавить("СальдоНаНачалоПериода." + ИмяПоказателя + "Начальный" + ВидОстатка + "ОстатокДт");
			СписокПолей.Добавить("СальдоНаНачалоПериода." + ИмяПоказателя + "Начальный" + ВидОстатка + "ОстатокКт");
			СписокПолей.Добавить("СальдоНаКонецПериода." + ИмяПоказателя + "Конечный" + ВидОстатка + "ОстатокДт");
			СписокПолей.Добавить("СальдоНаКонецПериода." + ИмяПоказателя + "Конечный" + ВидОстатка + "ОстатокКт");
		Иначе
			СписокПолей.Добавить("СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйОстатокДт");
			СписокПолей.Добавить("СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйОстатокКт");
			СписокПолей.Добавить("ОборотыЗаПериод." + ИмяПоказателя + "ОборотДт");
			СписокПолей.Добавить("ОборотыЗаПериод." + ИмяПоказателя + "ОборотКт");
			СписокПолей.Добавить("СальдоНаКонецПериода." + ИмяПоказателя + "КонечныйОстатокДт");
			СписокПолей.Добавить("СальдоНаКонецПериода." + ИмяПоказателя + "КонечныйОстатокКт");
			СписокПолей.Добавить("СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйРазвернутыйОстатокДт");
			СписокПолей.Добавить("СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйРазвернутыйОстатокКт");
			СписокПолей.Добавить("СальдоНаКонецПериода." + ИмяПоказателя + "КонечныйРазвернутыйОстатокДт");
			СписокПолей.Добавить("СальдоНаКонецПериода." + ИмяПоказателя + "КонечныйРазвернутыйОстатокКт");
		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры

//Процедура ВидПериодаПриИзменении(Форма, НачалоПериода, КонецПериода, МинимальнаяПериодичность) Экспорт
//	
//	Если Форма.ВидПериода = Форма.ДоступныеПериодыОтчета.ПроизвольныйПериод Тогда
//		ВыбратьПроизвольныйПериодОтчета(Форма, НачалоПериода, КонецПериода, МинимальнаяПериодичность);
//	Иначе
//		Если ЗначениеЗаполнено(НачалоПериода) Тогда
//			НачалоПериода = СтандартныеОтчетыКлиентСервер.НачалоПериодаОтчета(Форма.ВидПериода, НачалоПериода, Форма);
//			КонецПериода  = СтандартныеОтчетыКлиентСервер.КонецПериодаОтчета(Форма.ВидПериода, НачалоПериода, Форма);
//		Иначе
//			НачалоПериода = Неопределено;
//			КонецПериода  = Неопределено;
//		КонецЕсли;
//		
//		Список = СтандартныеОтчетыКлиентСервер.ПолучитьСписокПериодов(НачалоПериода, Форма.ВидПериода, Форма);
//		ЭлементСписка = Список.НайтиПоЗначению(НачалоПериода);
//		Если ЭлементСписка <> Неопределено тогда
//			Форма.Период = ЭлементСписка.Представление;
//		КонецЕсли;
//	КонецЕсли;
//	
//КонецПроцедуры

//Процедура ПериодПриИзменении(Форма, НачалоПериода, КонецПериода, Элемент) Экспорт
//	
//	Если ПустаяСтрока(Форма.Период) Тогда
//		НачалоПериода = Неопределено;
//		КонецПериода  = Неопределено;
//	КонецЕсли;
//	
//КонецПроцедуры

//Процедура ВыбратьПроизвольныйПериодОтчета(Форма, НачалоПериода, КонецПериода, МинимальнаяПериодичность) Экспорт
//	
//	Если МинимальнаяПериодичность = Неопределено тогда
//		МинимальнаяПериодичность = Форма.ДоступныеПериодыОтчета.День;
//	КонецЕсли;

//	ПараметрыФормы = Новый Структура("НачалоПериода, КонецПериода, МинимальныйПериод, ВидПериода", 
//		НачалоПериода, КонецПериода, Форма.ДоступныеПериодыОтчета.День, "ВидПериода");
//	НастройкаПериода = ОткрытьФормуМодально("ОбщаяФорма.ВыборПроизвольногоПериода", ПараметрыФормы, Форма);
//	
//	Если НастройкаПериода = Неопределено Тогда
//		Возврат;
//	КонецЕсли;
//	
//	НачалоПериода = НастройкаПериода.НачалоПериода;
//	КонецПериода  = НастройкаПериода.КонецПериода;
//	
//	Форма.ВидПериода = СтандартныеОтчетыКлиентСервер.ПолучитьВидПериода(НачалоПериода, КонецПериода, Форма);
//	Форма.Период     = СтандартныеОтчетыКлиентСервер.ПолучитьПредставлениеПериодаОтчета(Форма.ВидПериода, 
//		НастройкаПериода.НачалоПериода, НастройкаПериода.КонецПериода, Форма);	
//	
//КонецПроцедуры
	
//Процедура ПериодНачалоВыбораИзСписка(Форма, НачалоПериода, КонецПериода, Элемент, СтандартнаяОбработка) Экспорт
//	
//	Если Форма.ВидПериода = Форма.ДоступныеПериодыОтчета.ПроизвольныйПериод Тогда
//		ВыбратьПроизвольныйПериодОтчета(Форма, НачалоПериода, КонецПериода, Форма.ДоступныеПериодыОтчета.День);
//		СтандартнаяОбработка = Ложь;
//	Иначе
//		Если НачалоПериода = '00010101' Тогда
//			НачалоПериода = СтандартныеОтчетыКлиентСервер.НачалоПериодаОтчета(Форма.ВидПериода, ТекущаяДата(), Форма);
//		КонецЕсли;
//		ВыбранныйПериод      = ВыбратьПериодОтчета(Форма, Элемент, СтандартнаяОбработка, НачалоПериода);
//		СтандартнаяОбработка = Ложь;
//		Если ВыбранныйПериод = Неопределено Тогда
//			НачалоПериода = Неопределено;
//			Возврат;
//		КонецЕсли;
//		Форма.Период = ВыбранныйПериод.Представление;
//		
//		НачалоПериода = ВыбранныйПериод.Значение;
//		КонецПериода  = СтандартныеОтчетыКлиентСервер.КонецПериодаОтчета(Форма.ВидПериода, ВыбранныйПериод.Значение, Форма);
//	КонецЕсли;
//	
//КонецПроцедуры

//Процедура ПериодОбработкаВыбора(Форма, НачалоПериода, КонецПериода, Элемент, ВыбранноеЗначение, СтандартнаяОбработка) Экспорт
//	
//	Если ТипЗнч(ВыбранноеЗначение) = Тип("Дата") Тогда
//		НачалоПериода = СтандартныеОтчетыКлиентСервер.НачалоПериодаОтчета(Форма.ВидПериода, ВыбранноеЗначение, Форма);
//		КонецПериода  = СтандартныеОтчетыКлиентСервер.КонецПериодаОтчета(Форма.ВидПериода, ВыбранноеЗначение, Форма);
//		
//		ВыбранноеЗначение = СтандартныеОтчетыКлиентСервер.ПолучитьПредставлениеПериодаОтчета(Форма.ВидПериода, 
//			НачалоПериода, КонецПериода, Форма);
//			
//		Форма.Период = ВыбранноеЗначение;
//		СтандартнаяОбработка = Ложь;
//	КонецЕсли;
//	
//КонецПроцедуры

//Процедура ПериодАвтоПодбор(Форма, НачалоПериода, КонецПериода, Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка) Экспорт
//	
//	ДанныеВыбора = СтандартныеОтчетыКлиентСервер.ПодобратьПериодОтчета(Форма.ВидПериода, Текст, 
//		НачалоПериода, КонецПериода, Форма);
//		
//	СтандартнаяОбработка = Ложь;
//	
//КонецПроцедуры

//Процедура ПериодОкончаниеВводаТекста(Форма, НачалоПериода, КонецПериода, Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка) Экспорт
//	
//	Если ПустаяСтрока(Текст) Тогда
//		Возврат;
//	КонецЕсли;
//	
//	ДанныеВыбора = СтандартныеОтчетыКлиентСервер.ПодобратьПериодОтчета(Форма.ВидПериода, Текст, 
//		НачалоПериода, КонецПериода, Форма);
//		
//	СтандартнаяОбработка = Ложь;	
//	
//КонецПроцедуры

Процедура ОбработкаРасшифровкиСтандартногоОтчета(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка) Экспорт
	
	//Исправляем ошибку с "зависанием" данных расшифровки
	//ОбновитьДанныеРасшифровки(ФормаОтчета);
	
	СтандартнаяОбработка = Ложь;
	
	ИдентификаторОбъекта = СтандартныеОтчетыКлиентСервер.ПолучитьИдентификаторОбъекта(ФормаОтчета);
	
	СтруктураРасшифровкиДляМеню = Новый Структура("Адрес", ФормаОтчета.ДанныеРасшифровки);
	ПараметрыРасшифровкиДляМеню = УправленческийУчетПовтИсп.ПолучитьПараметрыРасшифровкиОтчетаДляМеню(СтруктураРасшифровкиДляМеню, ИдентификаторОбъекта, Расшифровка);
	
	ЗаполняемыеНастройки = Новый Структура("Показатели, Группировка, Отбор", Ложь, Истина, Ложь);
	Если ПараметрыРасшифровкиДляМеню.ОткрытьЗначение Тогда
		ТекФорма = БюджетныйНаСервере.ПолучитьФормуДокумента(ПараметрыРасшифровкиДляМеню.Значение);
		Если ПараметрыРасшифровкиДляМеню.Свойство("НомерСтроки") Тогда
			ОткрытьФорму(ТекФорма, Новый Структура("Ключ, НомерСтроки", ПараметрыРасшифровкиДляМеню.Значение, ПараметрыРасшифровкиДляМеню.НомерСтроки)); 
			Возврат;
		КонецЕсли;
		ПоказатьЗначение(Неопределено, ПараметрыРасшифровкиДляМеню.Значение);
	Иначе
		СписокПунктовМеню = ПараметрыРасшифровкиДляМеню.СписокПунктовМеню;
		Если СписокПунктовМеню.Количество() = 1 Тогда
			СтруктураРасшифровки = Новый Структура("Объект, Адрес, АдресСКД", ФормаОтчета.Отчет, ФормаОтчета.ДанныеРасшифровки, ФормаОтчета.СхемаКомпоновкиДанных);
			ПараметрыРасшифровки = УправленческийУчетПовтИсп.ПолучитьПараметрыРасшифровкиОтчета(СтруктураРасшифровки, ИдентификаторОбъекта, Расшифровка, ПараметрыРасшифровкиДляМеню);
			ИмяФормы = ПолучитьИмяФормыПоИДРасшифровки(СписокПунктовМеню[0].Значение);
			Если ИмяФормы = "Отчет.Д_КарточкаСчета.Форма.ФормаОтчета" Тогда
				ПараметрыФормы = Новый Структура("ВидРасшифровки, АдресНастроек, СформироватьПриОткрытии, ИДРасшифровки, ЗаполняемыеНастройки, ТекСценарий",
				1, ФормаОтчета.ДанныеРасшифровки, Истина, СписокПунктовМеню[0].Значение, ЗаполняемыеНастройки, ФормаОтчета.Отчет.СценарийПлана);
			Иначе
				ПараметрыФормы = Новый Структура("ВидРасшифровки, АдресНастроек, СформироватьПриОткрытии, ИДРасшифровки, ЗаполняемыеНастройки",
				1, ФормаОтчета.ДанныеРасшифровки, Истина, СписокПунктовМеню[0].Значение, ЗаполняемыеНастройки);
			КонецЕсли;
			ТекФорма = ПолучитьФорму(ИмяФормы, ПараметрыФормы, ФормаОтчета, Истина);
			ТекФорма.Элементы.ГруппаПанельНастроек.Видимость = ФормаОтчета.Элементы.ПанельНастроек.Пометка;
			//ТекФорма.Элементы.ГруппаПанельНастроек.Видимость = Ложь;
			ТекФорма.Открыть();
		ИначеЕсли СписокПунктовМеню.Количество() > 0 Тогда
			ПараметрыВыбора = Новый Структура;
			ПараметрыВыбора.Вставить("ФормаОтчета", 				ФормаОтчета);
			ПараметрыВыбора.Вставить("ИдентификаторОбъекта",  		ИдентификаторОбъекта);
			ПараметрыВыбора.Вставить("Расшифровка", 		  		Расшифровка);
			ПараметрыВыбора.Вставить("ПараметрыРасшифровкиДляМеню", ПараметрыРасшифровкиДляМеню);
			ПараметрыВыбора.Вставить("ЗаполняемыеНастройки", 		ЗаполняемыеНастройки);
			ФормаОтчета.ПоказатьВыборИзМеню(Новый ОписаниеОповещения("РезультатОбработкаРасшифровкиЗавершение", ЭтотОбъект, ПараметрыВыбора), СписокПунктовМеню, Элемент);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура РезультатОбработкаРасшифровкиЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	ВыбранноеДействие = ВыбранныйЭлемент;
	Если ВыбранноеДействие <> Неопределено Тогда
		СтруктураРасшифровки = Новый Структура("Объект, Адрес, АдресСКД", ДополнительныеПараметры.ФормаОтчета.Отчет, ДополнительныеПараметры.ФормаОтчета.ДанныеРасшифровки, ДополнительныеПараметры.ФормаОтчета.СхемаКомпоновкиДанных);
		ПараметрыРасшифровки = УправленческийУчетПовтИсп.ПолучитьПараметрыРасшифровкиОтчета(СтруктураРасшифровки, ДополнительныеПараметры.ИдентификаторОбъекта, ДополнительныеПараметры.Расшифровка, ДополнительныеПараметры.ПараметрыРасшифровкиДляМеню);
		Если ТипЗнч(ВыбранноеДействие.Значение) = Тип("Строка") Тогда
			ИмяФормы = ПолучитьИмяФормыПоИДРасшифровки(ВыбранноеДействие.Значение);
			ПараметрыФормы = Новый Структура("ВидРасшифровки, АдресНастроек, СформироватьПриОткрытии, ИДРасшифровки, ЗаполняемыеНастройки",
			1, ДополнительныеПараметры.ФормаОтчета.ДанныеРасшифровки, Истина, ВыбранноеДействие.Значение, ДополнительныеПараметры.ЗаполняемыеНастройки);
			ТекФорма = ПолучитьФорму(ИмяФормы, ПараметрыФормы, ДополнительныеПараметры.ФормаОтчета, Истина);
			Если НЕ ТекФорма.Элементы.Найти("ПанельНастроек") = Неопределено Тогда
				ТекФорма.Элементы.ГруппаПанельНастроек.Видимость = ДополнительныеПараметры.ФормаОтчета.Элементы.ПанельНастроек.Пометка;
			КонецЕсли;
			//ТекФорма.Элементы.ГруппаПанельНастроек.Видимость = Ложь;
			ТекФорма.Открыть();
		Иначе
			ПоказатьЗначение(Неопределено, ВыбранноеДействие.Значение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


Процедура ГруппировкаПередНачаломДобавления(Форма, Элемент, Отказ, Копирование, Родитель, Группа) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СхемаКомпоновкиДанных", Форма.СхемаКомпоновкиДанных);
	ПараметрыФормы.Вставить("Режим"          , "Группировка");
	ПараметрыФормы.Вставить("ИсключенныеПоля", Форма.ПолучитьЗапрещенныеПоля("Группировка"));
	ПараметрыФормы.Вставить("ТекущаяСтрока"  , Неопределено);
	ПараметрыВыбранногоПоля = ОткрытьФормуМодально("ОбщаяФорма.ФормаВыбораДоступногоПоля", ПараметрыФормы);
	
	Если ТипЗнч(ПараметрыВыбранногоПоля) = Тип("Структура") Тогда
		НоваяСтрока = Форма.Отчет.Группировка.Добавить();
		НоваяСтрока.Использование = Истина;
		НоваяСтрока.Поле          = ПараметрыВыбранногоПоля.Поле;
		НоваяСтрока.Представление = ПараметрыВыбранногоПоля.Заголовок;
	КонецЕсли;
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура ГруппировкаПередНачаломИзменения(Форма, Элемент, Отказ) Экспорт
	
	Если Элемент.ТекущийЭлемент = Форма.Элементы.ГруппировкаПредставление Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СхемаКомпоновкиДанных", Форма.СхемаКомпоновкиДанных);
		ПараметрыФормы.Вставить("Режим"          , "Группировка");
		ПараметрыФормы.Вставить("ИсключенныеПоля", Форма.ПолучитьЗапрещенныеПоля("Группировка"));
		ПараметрыФормы.Вставить("ТекущаяСтрока"  , Элемент.ТекущиеДанные.Поле);
		ПараметрыВыбранногоПоля = ОткрытьФормуМодально("ОбщаяФорма.ФормаВыбораДоступногоПоля", ПараметрыФормы);
		
		Если ТипЗнч(ПараметрыВыбранногоПоля) = Тип("Структура") Тогда
			НоваяСтрока = Элемент.ТекущиеДанные;
			НоваяСтрока.Использование = Истина;
			НоваяСтрока.Поле          = ПараметрыВыбранногоПоля.Поле;
			НоваяСтрока.Представление = ПараметрыВыбранногоПоля.Заголовок;
		КонецЕсли;
		
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтборыПередНачаломДобавления(Форма, Элемент, Отказ, Копирование, Родитель, Группа) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СхемаКомпоновкиДанных", Форма.СхемаКомпоновкиДанных);
	ПараметрыФормы.Вставить("Режим"                , "Отбор");
	ПараметрыФормы.Вставить("ИсключенныеПоля"      , Форма.ПолучитьЗапрещенныеПоля("Отбор"));
	ПараметрыФормы.Вставить("ТекущаяСтрока"        , Неопределено);
	ПараметрыВыбранногоПоля = ОткрытьФормуМодально("ОбщаяФорма.ФормаВыбораДоступногоПоля", ПараметрыФормы);
	
	Если ТипЗнч(ПараметрыВыбранногоПоля) = Тип("Структура") Тогда
		
		Если Элемент.ТекущаяСтрока = Неопределено Тогда
			ТекущаяСтрока = Неопределено;
		Иначе
			ТекущаяСтрока = Форма.Отчет.КомпоновщикНастроек.Настройки.Отбор.ПолучитьОбъектПоИдентификатору(Элемент.ТекущаяСтрока);
		КонецЕсли;

		Если ТипЗнч(ТекущаяСтрока) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			ЭлементОтбора = ТекущаяСтрока.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ИначеЕсли ТипЗнч(ТекущаяСтрока) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Если ТекущаяСтрока.Родитель <> Неопределено Тогда
				ЭлементОтбора = ТекущаяСтрока.Родитель.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			Иначе
				ЭлементОтбора = Форма.Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			КонецЕсли;
		Иначе
			ЭлементОтбора = Форма.Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		КонецЕсли;
		
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ПараметрыВыбранногоПоля.Поле);
		Если Строка(ПараметрыВыбранногоПоля.Поле) = "Организация" Тогда
			ЭлементОтбора.ПравоеЗначение = Форма.Отчет.Организация;
		ИначеЕсли Строка(ПараметрыВыбранногоПоля.Поле) = "Подразделение" Тогда 
			ЭлементОтбора.ПравоеЗначение = Форма.Отчет.Подразделение;
		ИначеЕсли Строка(ПараметрыВыбранногоПоля.Поле) = "СценарийПлана" Тогда 
			ЭлементОтбора.ПравоеЗначение = Форма.Отчет.СценарийПлана;
		КонецЕсли;
		ЭлементОтбора.ВидСравнения = ПараметрыВыбранногоПоля.ВидСравнения;
		
		Элемент.ТекущаяСтрока = Форма.Отчет.КомпоновщикНастроек.Настройки.Отбор.ПолучитьИдентификаторПоОбъекту(ЭлементОтбора);
		
	КонецЕсли;
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура ОтборыПередНачаломИзменения(Форма, Элемент, Отказ) Экспорт
	
	Если (Найти(Элемент.ТекущийЭлемент.Имя, "ОтборыЛевоеЗначение") > 0 И ТипЗнч(Элемент.ТекущиеДанные.ЛевоеЗначение) = Тип("ПолеКомпоновкиДанных")) Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СхемаКомпоновкиДанных", Форма.СхемаКомпоновкиДанных);
		ПараметрыФормы.Вставить("Режим"                , "Отбор");
		ПараметрыФормы.Вставить("ИсключенныеПоля"      , Форма.ПолучитьЗапрещенныеПоля("Отбор"));
		ПараметрыФормы.Вставить("ТекущаяСтрока"        , Элемент.ТекущиеДанные.ЛевоеЗначение);
		ПараметрыВыбранногоПоля = ОткрытьФормуМодально("ОбщаяФорма.ФормаВыбораДоступногоПоля", ПараметрыФормы);
		
		Если ТипЗнч(ПараметрыВыбранногоПоля) = Тип("Структура") Тогда
			
			ТекущаяСтрока = Форма.Отчет.КомпоновщикНастроек.Настройки.Отбор.ПолучитьОбъектПоИдентификатору(Элемент.ТекущаяСтрока);
			
			Если Найти(Элемент.ТекущийЭлемент.Имя, "ОтборыЛевоеЗначение") > 0 Тогда 
				ТекущаяСтрока.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ПараметрыВыбранногоПоля.Поле);
			КонецЕсли;
		КонецЕсли;
		
		Отказ = Истина;
	КонецЕсли;	
	
КонецПроцедуры

Процедура ДополнительныеПоляПередНачаломДобавления(Форма, Элемент, Отказ, Копирование, Родитель, Группа) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СхемаКомпоновкиДанных", Форма.СхемаКомпоновкиДанных);
	ПараметрыФормы.Вставить("Режим"                , "Выбор");
	ПараметрыФормы.Вставить("ИсключенныеПоля"      , Форма.ПолучитьЗапрещенныеПоля("Выбор"));
	ПараметрыФормы.Вставить("ТекущаяСтрока"        , Неопределено);
	ПараметрыВыбранногоПоля = ОткрытьФормуМодально("ОбщаяФорма.ФормаВыбораДоступногоПоля", ПараметрыФормы);
	
	Если ТипЗнч(ПараметрыВыбранногоПоля) = Тип("Структура") Тогда
		НоваяСтрока = Форма.Отчет.ДополнительныеПоля.Добавить();
		НоваяСтрока.Использование = Истина;
		НоваяСтрока.Поле          = ПараметрыВыбранногоПоля.Поле;
		НоваяСтрока.Представление = ПараметрыВыбранногоПоля.Заголовок;
	КонецЕсли;
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура ДополнительныеПоляПередНачаломИзменения(Форма, Элемент, Отказ) Экспорт
	
	Если Элемент.ТекущийЭлемент = Форма.Элементы.ДополнительныеПоляПредставление Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СхемаКомпоновкиДанных", Форма.СхемаКомпоновкиДанных);
		ПараметрыФормы.Вставить("Режим"                , "Выбор");
		ПараметрыФормы.Вставить("ИсключенныеПоля"      , Форма.ПолучитьЗапрещенныеПоля("Выбор"));
		ПараметрыФормы.Вставить("ТекущаяСтрока"        , Элемент.ТекущиеДанные.Поле);
		ПараметрыВыбранногоПоля = ОткрытьФормуМодально("ОбщаяФорма.ФормаВыбораДоступногоПоля", ПараметрыФормы);
		
		Если ТипЗнч(ПараметрыВыбранногоПоля) = Тип("Структура") Тогда
			НоваяСтрока = Элемент.ТекущиеДанные;
			НоваяСтрока.Использование = Истина;
			НоваяСтрока.Поле          = ПараметрыВыбранногоПоля.Поле;
			НоваяСтрока.Представление = ПараметрыВыбранногоПоля.Заголовок;
		КонецЕсли;
		
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура СортировкаПередНачаломДобавления(Форма, Элемент, Отказ, Копирование, Родитель, Группа) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СхемаКомпоновкиДанных", Форма.СхемаКомпоновкиДанных);
	ПараметрыФормы.Вставить("Режим"                , "Порядок");
	ПараметрыФормы.Вставить("ИсключенныеПоля"      , Форма.ПолучитьЗапрещенныеПоля("Порядок"));
	ПараметрыФормы.Вставить("ТекущаяСтрока"        , Неопределено);
	ПараметрыВыбранногоПоля = ОткрытьФормуМодально("ОбщаяФорма.ФормаВыбораДоступногоПоля", ПараметрыФормы);
	
	Если ТипЗнч(ПараметрыВыбранногоПоля) = Тип("Структура") Тогда
		НоваяСтрока = Форма.Отчет.КомпоновщикНастроек.Настройки.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		НоваяСтрока.Использование     = Истина;
		НоваяСтрока.Поле              = Новый ПолеКомпоновкиДанных(ПараметрыВыбранногоПоля.Поле);
		НоваяСтрока.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	КонецЕсли;
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура СортировкаПередНачаломИзменения(Форма, Элемент, Отказ) Экспорт
	
	Если Найти(Элемент.ТекущийЭлемент.Имя, "СортировкаПоле") = 1 Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СхемаКомпоновкиДанных", Форма.СхемаКомпоновкиДанных);
		ПараметрыФормы.Вставить("Режим"          , "Порядок");
		ПараметрыФормы.Вставить("ИсключенныеПоля", Форма.ПолучитьЗапрещенныеПоля("Порядок"));
		ПараметрыФормы.Вставить("ТекущаяСтрока"  , Элемент.ТекущиеДанные.Поле);
		ПараметрыВыбранногоПоля = ОткрытьФормуМодально("ОбщаяФорма.ФормаВыбораДоступногоПоля", ПараметрыФормы);
		
		Если ТипЗнч(ПараметрыВыбранногоПоля) = Тип("Структура") Тогда
			РедактируемаяСтрока = Форма.Отчет.КомпоновщикНастроек.Настройки.Порядок.ПолучитьОбъектПоИдентификатору(Элемент.ТекущаяСтрока);
			
			РедактируемаяСтрока.Использование = Истина;
			РедактируемаяСтрока.Поле          = Новый ПолеКомпоновкиДанных(ПараметрыВыбранногоПоля.Поле);
		КонецЕсли;
		
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьИмяФормыПоИДРасшифровки(ИДРасшифровки)
	
	ИмяОбъекта = ИДРасшифровки;
	ШаблонИмениФормы = "Отчет.%ИмяОбъекта%.Форма.ФормаОтчета";
	
	Если ИДРасшифровки = "УЧ_ОтчетПоУчетномуРегистру" Тогда
		ШаблонИмениФормы = "Отчет.УЧ_ОтчетПоУчетномуРегистру.ФормаОбъекта";
	КонецЕсли;
	
	Если ИДРасшифровки = "ОборотыСчетаПоДням" 
		Или ИДРасшифровки = "ОборотыСчетаПоМесяцам" Тогда
		ИмяОбъекта = "ОборотыСчета";
	КонецЕсли;
	
	Возврат СтрЗаменить(ШаблонИмениФормы, "%ИмяОбъекта%", ИмяОбъекта);
	
КонецФункции

//Функция ВыбратьПериодОтчета(Форма, Элемент, СтандартнаяОбработка, НачалоПериода)
//	
//	Список = СтандартныеОтчетыКлиентСервер.ПолучитьСписокПериодов(НачалоПериода, Форма.ВидПериода, Форма);
//	Если Список.Количество() = 0 Тогда
//		СтандартнаяОбработка = Ложь;
//		Возврат Неопределено;
//	КонецЕсли;
//	
//	ЭлементСписка = Список.НайтиПоЗначению(НачалоПериода);
//	ВыбранныйПериод = Форма.ВыбратьИзСписка(Список, Элемент, ЭлементСписка);
//	
//	Если ВыбранныйПериод = Неопределено тогда
//		Возврат Неопределено;
//	КонецЕсли;
//	
//	Индекс = Список.Индекс(ВыбранныйПериод);
//	Если Индекс = 0 ИЛИ Индекс = Список.Количество() - 1 тогда
//		ВыбранныйПериод = ВыбратьПериодОтчета(Форма, Элемент, СтандартнаяОбработка, ВыбранныйПериод.Значение);
//	КонецЕсли;
//	
//	Возврат ВыбранныйПериод;
//	
//КонецФункции

Процедура ТабличноеПолеПоСчетамГруппировкаПередНачаломДобавления(ФормаОтчета, ИмяЭлемента, Элемент, Отказ, Копирование, Родитель, Группа) Экспорт
	
	Отказ = Истина;
	НоваяСтрока = ФормаОтчета.Отчет[ИмяЭлемента].Добавить();
	НоваяСтрока.Использование = Истина;
	
КонецПроцедуры

Процедура ТабличноеПолеПоСчетамСчетПриИзменении(ФормаОтчета, ИмяЭлемента, Элемент) Экспорт
	
	ТекущиеДанные = ФормаОтчета.Элементы[ИмяЭлемента].ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Если ЗначениеЗаполнено(ТекущиеДанные.Счет) Тогда
			ДанныеСчета = УправленческийУчетПовтИсп.ПолучитьСвойстваСчета(ТекущиеДанные.Счет);
			Если ДанныеСчета.КоличествоСубконто = 0 Тогда
				ТекущиеДанные.ПоСубсчетам = Истина;
				ТекущиеДанные.ПоСубконто    = СтрЗаменить(ТекущиеДанные.ПоСубконто, "+", "-");
				ТекущиеДанные.Представление = "";
			Иначе
				ТекущиеДанные.ПоСубсчетам = Ложь;
				ТекущиеДанные.ПоСубконто    = СтрЗаменить(ТекущиеДанные.ПоСубконто, "-", "+");
				ТекущиеДанные.Представление = "";
				СтрокаПоСубконто    = "";
				СтрокаПредставление = "";
				Для Индекс = 1 По ДанныеСчета.КоличествоСубконто Цикл
					СтрокаПоСубконто    = СтрокаПоСубконто + "+" + Индекс;
					СтрокаПредставление = СтрокаПредставление + ДанныеСчета["ВидСубконто" + Индекс + "Наименование"] + ", ";
				КонецЦикла;
				СтрокаПредставление = Лев(СтрокаПредставление, СтрДлина(СтрокаПредставление) - 2);
				ТекущиеДанные.ПоСубконто    = СтрокаПоСубконто;
				ТекущиеДанные.Представление = СтрокаПредставление;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ТабличноеПолеПоСчетамПоСубсчетамПриИзменении(ФормаОтчета, ИмяЭлемента, Элемент) Экспорт
	
	ТекущиеДанные = ФормаОтчета.Элементы[ИмяЭлемента].ТекущиеДанные;
	ДанныеСчета = УправленческийУчетПовтИсп.ПолучитьСвойстваСчета(ТекущиеДанные.Счет);
	Если ТекущиеДанные <> Неопределено Тогда
		Если ТекущиеДанные.ПоСубсчетам Тогда
			Если ИмяЭлемента = "РазвернутоеСальдо" Тогда
				ТабличноеПолеПоСчетамПредставлениеОчистка(ФормаОтчета, ИмяЭлемента, Элемент, Ложь);
			КонецЕсли; 
		Иначе
			Если ПустаяСтрока(ТекущиеДанные.Представление) Тогда
				ТекущиеДанные.ПоСубсчетам = Истина;
				Возврат;
			КонецЕсли;
			ТекущиеДанные.ПоСубконто    = СтрЗаменить(ТекущиеДанные.ПоСубконто, "-", "+");
			ТекущиеДанные.Представление = "";
			СтрокаПоСубконто    = "";
			СтрокаПредставление = "";
			Для Индекс = 1 По ДанныеСчета.КоличествоСубконто Цикл
				СтрокаПоСубконто    = СтрокаПоСубконто + "+" + Индекс;
				СтрокаПредставление = СтрокаПредставление + ДанныеСчета["ВидСубконто" + Индекс + "Наименование"] + ", ";
			КонецЦикла;
			СтрокаПредставление = Лев(СтрокаПредставление, СтрДлина(СтрокаПредставление) - 2);
			ТекущиеДанные.ПоСубконто    = СтрокаПоСубконто;
			ТекущиеДанные.Представление = СтрокаПредставление;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ТабличноеПолеПоСчетамПредставлениеНачалоВыбора(ФормаОтчета, ИмяЭлемента, Элемент, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	СтрокаПоСубконто = ФормаОтчета.Элементы[ИмяЭлемента].ТекущиеДанные.ПоСубконто;
	Счет = ФормаОтчета.Элементы[ИмяЭлемента].ТекущиеДанные.Счет;
	ДанныеСчета = УправленческийУчетПовтИсп.ПолучитьСвойстваСчета(Счет);
	СписокВидовСубконто = Новый СписокЗначений;
	Если ПустаяСтрока(СтрокаПоСубконто) Тогда		
		Для Индекс = 1 По ДанныеСчета.КоличествоСубконто Цикл
			СписокВидовСубконто.Добавить(ДанныеСчета["ВидСубконто" + Индекс], ДанныеСчета["ВидСубконто" + Индекс + "Наименование"]);
		КонецЦикла;
	Иначе
		КоличествоСубконто = СтрДлина(СтрокаПоСубконто) / 2;
		Для Индекс = 1 По КоличествоСубконто Цикл
			СписокВидовСубконто.Добавить(ДанныеСчета["ВидСубконто" + Сред(СтрокаПоСубконто, Индекс*2, 1)], ДанныеСчета["ВидСубконто" + Сред(СтрокаПоСубконто, Индекс*2, 1) + "Наименование"], ?(Сред(СтрокаПоСубконто, Индекс * 2 - 1, 1) = "+", Истина, Ложь));
		КонецЦикла;
	КонецЕсли;	
	ОткрытьФорму("ОбщаяФорма.ФормаНастройкаПоСубконто", Новый Структура("СписокВидовСубконто", СписокВидовСубконто), Элемент);
	
КонецПроцедуры

Процедура ТабличноеПолеПоСчетамПредставлениеОчистка(ФормаОтчета, ИмяЭлемента, Элемент, СтандартнаяОбработка) Экспорт
		
	ФормаОтчета.Элементы[ИмяЭлемента].ТекущиеДанные.ПоСубконто    = СтрЗаменить(ФормаОтчета.Элементы[ИмяЭлемента].ТекущиеДанные.ПоСубконто, "+", "-");
	ФормаОтчета.Элементы[ИмяЭлемента].ТекущиеДанные.Представление = "";
	
КонецПроцедуры

Процедура ТабличноеПолеПоСчетамПредставлениеОбработкаВыбора(ФормаОтчета, ИмяЭлемента, Элемент, ВыбранноеЗначение, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = ФормаОтчета.Элементы[ИмяЭлемента].ТекущиеДанные;
	ДанныеСчета = УправленческийУчетПовтИсп.ПолучитьСвойстваСчета(ТекущиеДанные.Счет);
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СписокЗначений") Тогда 
		СтрокаПоСубконто = "";
		СтрокаПредставление = "";
		Для Каждого ЭлементСписка Из ВыбранноеЗначение Цикл
			Если ЭлементСписка.Пометка Тогда
				СтрокаПоСубконто    = СтрокаПоСубконто + "+";
				СтрокаПредставление = СтрокаПредставление + Строка(ЭлементСписка.Значение) + ", ";
			Иначе
				СтрокаПоСубконто = СтрокаПоСубконто + "-";
			КонецЕсли;
			
			Для Индекс = 1 По ДанныеСчета.КоличествоСубконто Цикл 
				Если ДанныеСчета["ВидСубконто" + Индекс] = ЭлементСписка.Значение Тогда
					СтрокаПоСубконто = СтрокаПоСубконто + Индекс;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		СтрокаПредставление = Лев(СтрокаПредставление, СтрДлина(СтрокаПредставление) - 2);
		
		Если ПустаяСтрока(СтрокаПредставление) И (ДанныеСчета.Свойство("ЗапретитьИспользоватьВПроводках") И Не ДанныеСчета.ЗапретитьИспользоватьВПроводках) Тогда
			Возврат;
		КонецЕсли;
		ТекущиеДанные.ПоСубконто    = СтрокаПоСубконто;
		ТекущиеДанные.Представление = СтрокаПредставление;
		
		Если ПустаяСтрока(СтрокаПредставление) Тогда
			ТекущиеДанные.ПоСубсчетам = Истина;
		Иначе
			Если ИмяЭлемента = "РазвернутоеСальдо" Тогда
				ТекущиеДанные.ПоСубсчетам = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьДанныеРасшифровки(Форма)
	ТипОтчета =  Лев(Форма.ИмяФормы,Найти(Форма.ИмяФормы,".Форма.")-1);
	ТипОтчета =  СтрЗаменить(ТипОтчета,"Отчет.","ОтчетОбъект." );
	Если ТипОтчета = "ОтчетОбъект.сабОборотноСальдоваяВедомостьПоСчету" ИЛИ ТипОтчета = "ОтчетОбъект.сабОборотноСальдоваяВедомость" ИЛИ ТипОтчета = "ОтчетОбъект.сабАнализСчета" 
		ИЛИ ТипОтчета = "ОтчетОбъект.КЗ_ОборотноСальдоваяВедомостьПоСчету" ИЛИ ТипОтчета = "ОтчетОбъект.КЗ_ОборотноСальдоваяВедомость" ИЛИ ТипОтчета = "ОтчетОбъект.КЗ_АнализСчета"
		ИЛИ ТипОтчета = "ОтчетОбъект.Д_ОборотноСальдоваяВедомостьПоСчету"
		Тогда
		Форма.ДанныеРасшифровки = УправленческийУчетПовтИсп.ОбновитьДанныеРасшифровкиНаСервере(Форма.СхемаКомпоновкиДанных, Форма.ДанныеРасшифровки, Форма.отчет,ТипОтчета);	
	КонецЕсли; 
	
КонецПроцедуры

