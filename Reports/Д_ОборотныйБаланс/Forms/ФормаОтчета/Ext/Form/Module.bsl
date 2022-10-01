﻿ 

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ВидимостьСпискаПредприятий = ?(БюджетныйНаСервере.ПолучитьПредприятия().Количество() > 1, 1, 0);
	//Элементы.Предприятие1.Видимость = ВидимостьСпискаПредприятий;
	
	БюджетныйНаСервере.ЗаполнитьСписокПредприятия(Отчет.Предприятие, 0);	
КонецПроцедуры

&НаКлиенте
Процедура ТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь; 
	ПараметрыРасшифровки = Новый Структура;
	
	ТекСценарий = Неопределено;
	ТекПериод = Неопределено;
	
	СписокСчетов = Новый СписокЗначений;
	
	Для каждого ЭлСчет Из Расшифровка Цикл
		
		Если ТипЗнч(ЭлСчет) = Тип("СправочникСсылка.СценарииПланирования") Тогда
			ТекСценарий = ЭлСчет;
			Продолжить;
		КонецЕсли;
		
		Если ТипЗнч(ЭлСчет) = Тип("СтандартныйПериод") Тогда
			ТекПериод = ЭлСчет;
			Продолжить;
		КонецЕсли;
		
		СписокСчетов.Добавить(ЭлСчет);		
		
	КонецЦикла;
	
	СписокПредприятий = Новый СписокЗначений;
	
	Для Каждого ЭлП Из Отчет.Предприятие Цикл
		
		Если ЭлП.Пометка Тогда
			СписокПредприятий.Добавить(ЭлП.Значение);
		КонецЕсли;	
			
	КонецЦикла;
	
	СцФакт = ПроверитьТекущийСценарий(ТекСценарий); 
	
	Если СцФакт Тогда	
		ОСВ = ПолучитьФорму("Отчет.Уч_ОСВ.Форма",,,Истина);
		ОСВ.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[0].Значение.ДатаНачала = ТекПериод.ДатаНачала;
		ОСВ.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[0].Значение.ДатаОкончания = ТекПериод.ДатаОкончания;
		ОСВ.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[0].Значение.Вариант = ТекПериод.Вариант;
		ОСВ.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[0].Использование = Истина; 		
		ОСВ.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[2].Значение = СписокПредприятий;
		ОСВ.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[2].Использование = Истина;
		ОСВ.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[1].Значение = СписокСчетов;
		ОСВ.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[1].Использование = Истина;
	Иначе
		ОСВ = ПолучитьФорму("Отчет.Д_ОСВ.Форма",,,Истина);
		ОСВ.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[0].Значение = ТекПериод;
		ОСВ.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[0].Использование = Истина;
		ОСВ.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[1].Значение = СписокПредприятий;
		ОСВ.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[1].Использование = Истина;
		ОСВ.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[2].Значение = СписокСчетов;
		ОСВ.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[2].Использование = Истина;
		ОСВ.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[3].Значение = ТекСценарий;
		ОСВ.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[3].Использование = Истина;
		
		//ОСВ.Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы[0].ПравоеЗначение = СписокПредприятий;
		//ОСВ.Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы[0].Использование = Истина;
		//ОСВ.Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы[1].ПравоеЗначение = СписокСчетов;
		//ОСВ.Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы[1].Использование = Истина;
		//ОСВ.Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы[2].ПравоеЗначение = ТекСценарий;
		//ОСВ.Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы[2].Использование = Истина;
		
	КонецЕсли;
	
	ОСВ.СкомпоноватьРезультат();
	ОСВ.Открыть();	
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Сценарий1") Тогда //вызван отчет извне с параметрами
		Отчет.Сценарий1 = Параметры.Сценарий1;
		Отчет.Сценарий2 = Параметры.Сценарий2;
		Отчет.Период = Параметры.Период;
		//Элементы.Группа.Видимость = Параметры.НастройкиВидимость;
		БюджетныйНаСервере.ЗаполнитьСписокПредприятия(Отчет.Предприятие, 0);
		Если ТипЗнч(Параметры.Предприятия) = Тип("Массив") ИЛИ ТипЗнч(Параметры.Предприятия) = Тип("СписокЗначений") Тогда
			Отчет.Предприятие.ЗаполнитьПометки(Истина);
		Иначе
			Отчет.Предприятие.НайтиПоЗначению(Параметры.Предприятие).Пометка = 1;		
		КонецЕсли;
		//Отчеты.Д_ОборотныйБаланс.ЗаполнитьТаблицу(0);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	Элементы.Группа.Видимость = 1 - Элементы.Группа.Видимость;
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьВсе(Команда)
	Отчет.Предприятие.ЗаполнитьПометки(1);
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	Отчет.Предприятие.ЗаполнитьПометки(0);
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьПериод(Команда)
	Элементы.Период.Видимость = 1 - Элементы.Период.Видимость;	
КонецПроцедуры

&НаКлиенте
Процедура Сценарий1ПриИзменении(Элемент)
	Отчет.Период.ДатаНачала = НачалоМесяца(БюджетныйНаСервере.ПолучитьПериодСценария(Отчет.Сценарий1).Дата1 + 60 * 60 * 24);
	Отчет.Период.ДатаОкончания = КонецМесяца(БюджетныйНаСервере.ПолучитьПериодСценария(Отчет.Сценарий1).Дата2);
КонецПроцедуры

&НаСервере
Функция ПолучитьСценарийФакта()
	возврат Справочники.СценарииПланирования.Факт;
КонецФункции // ()

&НаКлиенте
Процедура Сценарий2ПриИзменении(Элемент)
	Если НЕ Отчет.Сценарий2 = ПолучитьСценарийФакта() Тогда
		Отчет.Период.ДатаНачала = НачалоМесяца(БюджетныйНаСервере.ПолучитьПериодСценария(Отчет.Сценарий2).Дата1 + 60 * 60 * 24);
		Отчет.Период.ДатаОкончания = КонецМесяца(БюджетныйНаСервере.ПолучитьПериодСценария(Отчет.Сценарий2).Дата2);
	КонецЕсли;
	Если ПустаяСтрока(Отчет.Сценарий2) Тогда
		Сценарий1ПриИзменении(0);	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СводныйПриИзменении(Элемент)
	Элементы.Группа2.Видимость = 1 - Отчет.Сводный;
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	Элементы.Предприятие.Видимость = 0;
	Элементы.ЗакрытьНастройки.Видимость = 0;
	Элементы.ОткрытьНастройки.Видимость = 1;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройки(Команда)
	Элементы.Предприятие.Видимость = 1;
	Элементы.ЗакрытьНастройки.Видимость = 1;
	Элементы.ОткрытьНастройки.Видимость = 0;
КонецПроцедуры

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	ИтогоСумма = Формат(БюджетныйНаКлиенте.Просуммировать(Результат), "ЧДЦ=2");
	
	
КонецПроцедуры

&НаКлиенте
Процедура Сумма(Команда)
    БюджетныйНаКлиенте.КопироватьВБуфер(ИтогоСумма);
КонецПроцедуры


&НаКлиенте
Процедура Сформировать(Команда)
	
	ЭтаФорма.СкомпоноватьРезультат();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьТекущийСценарий(Сц)
	
	Возврат Сц = Справочники.СценарииПланирования.Факт;
	
КонецФункции
