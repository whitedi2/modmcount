﻿
&НаКлиенте
Процедура Согласовано(Команда)
	
	Если Не Задача.Заявка = Неопределено Тогда
		ПроверенНаСервере(Задача.Заявка);
		ОповеститьОбИзменении(Задача.Ссылка);
		Оповестить("ОбновитьСписокЗадач");
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверенНаСервере(ТекСсылка)
	
	НачатьТранзакцию();
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИзмененияРеквизитовОбъектовИБ.Объект,
	|	ИзмененияРеквизитовОбъектовИБ.ИмяРеквизита,
	|	ИзмененияРеквизитовОбъектовИБ.ИмяТабличнойЧасти,
	|	ЕстьNULL(ИзмененияРеквизитовОбъектовИБ.НомерСтрокиТЧ, 1) КАК НомерСтрокиТЧ,
	|	ИзмененияРеквизитовОбъектовИБ.СтароеЗначение,
	|	ИзмененияРеквизитовОбъектовИБ.НовоеЗначение
	|ИЗ
	|	РегистрСведений.ИзмененияРеквизитовОбъектовИБ КАК ИзмененияРеквизитовОбъектовИБ
	|ГДЕ
	|	ИзмененияРеквизитовОбъектовИБ.Объект = &Объект
	|	И НЕ ИзмененияРеквизитовОбъектовИБ.ИзменениеПроверено";
	Запрос.УстановитьПараметр("Объект", ТекСсылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	СправочникОбъект = ТекСсылка.ПолучитьОбъект();
	
	Пока Выборка.Следующий() Цикл
		//временная блокировка на реквизиты ТЧ
		Если ЗначениеЗаполнено(Выборка.ИмяТабличнойЧасти) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Выборка.ИмяРеквизита) Тогда
			Продолжить;
		КонецЕсли;	
		
		//	ТабличнаяЧасть = СправочникОбъект[Выборка.ИмяТабличнойЧасти];
		//	Если ТабличнаяЧасть.Получить(Выборка.НомерСтрокиТЧ - 1) = Неопределено Тогда
		//		СтрокаТЧ = ТабличнаяЧасть.Добавить();
		//	Иначе
		//		СтрокаТЧ = ТабличнаяЧасть.Получить(Выборка.НомерСтрокиТЧ - 1);
		//	КонецЕсли;
		//	СтрокаТЧ[Выборка.ИмяРеквизита] = Выборка.НовоеЗначение;;
		//КонецЕсли;
		
		Если Не СправочникОбъект.Метаданные().Реквизиты.Найти(Выборка.ИмяРеквизита) = Неопределено Тогда 
			СправочникОбъект[Выборка.ИмяРеквизита] = Выборка.НовоеЗначение;
		КонецЕсли;

	КонецЦикла;	
	
	СправочникОбъект.Записать();
	
	НаборЗаписей = РегистрыСведений.ИзмененияРеквизитовОбъектовИБ.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Объект.Установить(ТекСсылка);
	НаборЗаписей.Прочитать();
	
	Для Каждого Запись Из НаборЗаписей Цикл
		Запись.ИзменениеПроверено 	= Истина;
	КонецЦикла;	
	
	НаборЗаписей.Записать(Истина);
	
	НаборЗаписей = РегистрыСведений.ПроверкаОбъектовБД.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Объект.Установить(Задача.Заявка);
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	Запись 				= НаборЗаписей.Добавить();
	Запись.Объект	 	= Задача.Заявка;
	Запись.Статус 		= Перечисления.СтатусПриПроверкеОбъектовБД.Проверен;
	Запись.Проверен 	= Истина;
	НаборЗаписей.Записать();
	
	БПСервер.ВыполнитьЗадачу(Задача.Ссылка, ,Истина , Задача.Комментарии);
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

&НаКлиенте
Процедура НаДоработку(Команда)
	
	Если Не Задача.Заявка = Неопределено Тогда
		Если Не ЗначениеЗаполнено(Задача.Комментарии) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Введите комментарий отказа!";
			Сообщение.Сообщить();
			Возврат;
		КонецЕсли;	
		НаДоработкуНаСервере();
		ОповеститьОбИзменении(Задача.Ссылка);
		Оповестить("ОбновитьСписокЗадач");
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаменитьСсылки(Команда)
	
	Если Задача.Гиперссылка = Неопределено Тогда
		СтруктураПараметров = Новый Структура("Ссылка", Задача.Заявка);
		ОткрытьФорму("Обработка.ПоискИЗаменаЗначений.Форма.Форма", СтруктураПараметров);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПосмотретьИзменения(Команда)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Объект", Задача.Заявка);  
	ПараметрыОтбора.Вставить("ИзменениеПроверено", Ложь);  
	СтруктураПараметров = Новый Структура("Отбор", ПараметрыОтбора);
	ОткрытьФорму("РегистрСведений.ИзмененияРеквизитовОбъектовИБ.Форма.ФормаСписка", СтруктураПараметров);
	
КонецПроцедуры

&НаСервере
Процедура НаДоработкуНаСервере()
	
	НачатьТранзакцию();
	НоваяЗадача = Задачи.Задача.СоздатьЭлемент();
	НоваяЗадача.Заявка = Задача.Заявка;
	НоваяЗадача.Дата = ТекущаяДата();
	НаименованиеЗадачи = "Доработать";
	Если ТипЗнч(Задача.Заявка) = Тип("СправочникСсылка.Контрагенты") Тогда
		НаименованиеЗадачи = "Доработать контрагента";
	ИначеЕсли ТипЗнч(Задача.Заявка) = Тип("СправочникСсылка.Организации") Тогда
		НаименованиеЗадачи = "Доработать юр. лицо";
	ИначеЕсли ТипЗнч(Задача.Заявка) = Тип("СправочникСсылка.Номенклатура") Тогда
		НаименованиеЗадачи = "Доработать номенклатуру";
	КонецЕсли;
	НоваяЗадача.Наименование = НаименованиеЗадачи;
	НоваяЗадача.Автор = ПараметрыСеанса.ТекущийПользователь;
	НоваяЗадача.Описание = "" + ТекущаяДата() + " " + ПараметрыСеанса.ТекущийПользователь + " отправил задачу на доработку:
	|" + Задача.Комментарии;
	НоваяЗадача.Исполнитель = Задача.Автор;
	НоваяЗадача.Записать();
	//Если ЗначениеЗаполнено(Задача.БизнесПроцесс) Тогда
	//	НоваяЗадача.БизнесПроцесс = Задача.БизнесПроцесс;
	//	НоваяЗадача.ТочкаМаршрута = Задача.ТочкаМаршрута;
	//	БПОбъект = Задача.БизнесПроцесс.ПолучитьОбъект();
	//КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИзмененияРеквизитовОбъектовИБ.ИмяРеквизита,
	|	ИзмененияРеквизитовОбъектовИБ.Объект,
	|	ИзмененияРеквизитовОбъектовИБ.ИмяТабличнойЧасти,
	|	ИзмененияРеквизитовОбъектовИБ.НомерСтрокиТЧ
	|ИЗ
	|	РегистрСведений.ИзмененияРеквизитовОбъектовИБ КАК ИзмененияРеквизитовОбъектовИБ
	|ГДЕ
	|	ИзмененияРеквизитовОбъектовИБ.Объект = &Объект
	|	И НЕ ИзмененияРеквизитовОбъектовИБ.ИзменениеПроверено";
	Запрос.УстановитьПараметр("Объект", Задача.Заявка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НаборЗаписей = РегистрыСведений.ИзмененияРеквизитовОбъектовИБ.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ИмяРеквизита.Установить(Выборка.ИмяРеквизита);
		НаборЗаписей.Отбор.Объект.Установить(Выборка.Объект);
		НаборЗаписей.Отбор.ИмяТабличнойЧасти.Установить(Выборка.ИмяТабличнойЧасти);
		НаборЗаписей.Отбор.НомерСтрокиТЧ.Установить(Выборка.НомерСтрокиТЧ);
		НаборЗаписей.Прочитать();
		НаборЗаписей.Очистить();
		НаборЗаписей.Записать();
	КонецЦикла;
	
	НаборЗаписей = РегистрыСведений.ПроверкаОбъектовБД.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Объект.Установить(Задача.Заявка);
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	Запись 				= НаборЗаписей.Добавить();
	Запись.Объект	 	= Задача.Заявка;
	Если ТекущийВидПроверки = "Проверка нового" Тогда
		Запись.Статус 		= Перечисления.СтатусПриПроверкеОбъектовБД.Отклонен;
	Иначе
		Запись.Статус 		= Перечисления.СтатусПриПроверкеОбъектовБД.НаДоработке;
	КонецЕсли;	
	НаборЗаписей.Записать();
	
	Запись 			= РегистрыСведений.ДополнительныеСведения.СоздатьМенеджерЗаписи();
	Запись.Объект 	= НоваяЗадача.Ссылка;
	Запись.Свойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.СтатусЗадачиПоКонтрагентам;
	Если ТекущийВидПроверки = "Проверка нового" Тогда
		Запись.Значение = Перечисления.СтатусПриПроверкеОбъектовБД.Отклонен;
	Иначе
		Запись.Значение	= Перечисления.СтатусПриПроверкеОбъектовБД.НаДоработке;
	КонецЕсли;	
	Запись.Записать();
	
	БПСервер.ВыполнитьЗадачу(Задача.Ссылка, ,Ложь ,Задача.Комментарии);
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВозможностьСогласования = Ложь;
	
	Если (ТипЗнч(Задача.Заявка) = Тип("СправочникСсылка.Контрагенты") И (ПараметрыСеанса.ТекущийПользователь = ОбщегоНазначения.ПолучитьОтветственногоЗаСправочник(Перечисления.ТипыПроверяемыхСправочников.Контрагенты)))
			ИЛИ (ТипЗнч(Задача.Заявка) = Тип("СправочникСсылка.Должности") И ПараметрыСеанса.ТекущийПользователь = ОбщегоНазначения.ПолучитьОтветственногоЗаСправочник(Перечисления.ТипыПроверяемыхСправочников.Должности)) 
			ИЛИ (ТипЗнч(Задача.Заявка) = Тип("СправочникСсылка.Номенклатура") И ОтветственныйЗаНоменклатуру()) 
			ИЛИ (ТипЗнч(Задача.Заявка) = Тип("СправочникСсылка.Организации") И ПараметрыСеанса.ТекущийПользователь = ОбщегоНазначения.ПолучитьОтветственногоЗаСправочник(Перечисления.ТипыПроверяемыхСправочников.Организации)) Тогда
		ВозможностьСогласования = Истина;
	КонецЕсли;	
	
	Если Не ВозможностьСогласования Тогда
		Элементы.НаДоаботку.Видимость 			 = Ложь;
		Элементы.ФормаСогласовано.Видимость 	 = Ложь;
		Элементы.ПосмотретьИзменения.Видимость 	 = Ложь;
		Элементы.Проверить.Видимость 			 = Ложь;
		Элементы.ОК.Видимость 					 = Истина;
		Элементы.ОтказатьсяОтИмзенений.Видимость = Истина;
	КонецЕсли;
	
	Элементы.СравнитьКонтрагентаСГосРеестром.Видимость = (ТипЗнч(Задача.Заявка) = Тип("СправочникСсылка.Контрагенты"));
	
	ТекущийВидПроверки = ТекущийВидПроверки(Задача.Заявка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Если ТипЗнч(Задача.Заявка) = Тип("СправочникСсылка.Контрагенты") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Контрагент не был доработан! Выполнение задачи невозможно!");
		ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта", Новый Структура("Ключ", Задача.Заявка));
		Возврат;
	Иначе
		БПСервер.ВыполнитьЗадачу(Задача.Ссылка, ,Истина ,Задача.Комментарии);
		ОткрытьФорму(ПолучитьИмяФормы(), Новый Структура("Ключ", Задача.Заявка),,,ВариантОткрытияОкна.ОтдельноеОкно);
		Оповестить("ОбновитьСписокЗадач");
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОтветственныйЗаНоменклатуру()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОтветственныеЗаПроверкуСправочников.Ответственный КАК Ответственный
	|ПОМЕСТИТЬ ВТ_Ответственные
	|ИЗ
	|	РегистрСведений.ОтветственныеЗаПроверкуСправочников КАК ОтветственныеЗаПроверкуСправочников
	|ГДЕ
	|	ОтветственныеЗаПроверкуСправочников.ТипСправочника = &ТипСправочника
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Ответственные.Ответственный КАК Ответственный
	|ИЗ
	|	ВТ_Ответственные КАК ВТ_Ответственные
	|ГДЕ
	|	&Ответственный В
	|			(ВЫБРАТЬ
	|				ВТ_Ответственные.Ответственный
	|			ИЗ
	|				ВТ_Ответственные КАК ВТ_Ответственные)";
	Запрос.УстановитьПараметр("ТипСправочника", Перечисления.ТипыПроверяемыхСправочников.Номенклатура);
	Запрос.УстановитьПараметр("Ответственный", ПараметрыСеанса.ТекущийПользователь);

	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

&НаСервере
Функция ТекущийВидПроверки(ТекСсылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПроверкаОбъектовБД.Статус
	|ИЗ
	|	РегистрСведений.ПроверкаОбъектовБД КАК ПроверкаОбъектовБД
	|ГДЕ
	|	ПроверкаОбъектовБД.Объект = &Объект";
	Запрос.УстановитьПараметр("Объект", ТекСсылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.Статус = Перечисления.СтатусПриПроверкеОбъектовБД.НаПроверке Тогда
			Возврат "Проверка";
		ИначеЕсли Выборка.Статус = Перечисления.СтатусПриПроверкеОбъектовБД.ПроверкаНового Тогда
	        Возврат "Проверка нового";
		Иначе 
			Возврат "";
		КонецЕсли;
	КонецЦикла;	
	
КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОповеститьОЗакрытииФормыКонтрагента" Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьИмяФормы()
	
	Возврат "Справочник." + Задача.Заявка.Метаданные().Имя + ".ФормаОбъекта";
	
КонецФункции	

&НаКлиенте
Процедура ОтказатьсяОтИмзенений(Команда)
	БПСервер.ВыполнитьЗадачу(Задача.Ссылка, ,Истина ,Задача.Комментарии);
	ПроверенНаСервере(Задача.Заявка);
	Оповестить("ОбновитьСписокЗадач");
	Закрыть();
КонецПроцедуры

&НаСервере
Процедура ПроверитьНаСервере()
	
	ОбъектПроверки = Задача.Заявка;
	Если ТипЗнч(ОбъектПроверки) = Тип("СправочникСсылка.Контрагенты") Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Контрагенты.Ссылка КАК НайденныйОбъект,
		|	""Совпадают ИНН и КПП"" КАК Критерий,
		|	1 КАК Порядок,
		|	Контрагенты.Код
		|ПОМЕСТИТЬ ВТ_ИНН_КПП
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.ИНН = &ИНН
		|	И Контрагенты.КПП = &КПП
		|	И Контрагенты.Ссылка <> &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ИНН_КПП.НайденныйОбъект,
		|	ВТ_ИНН_КПП.Критерий,
		|	ВТ_ИНН_КПП.Порядок,
		|	ВТ_ИНН_КПП.Код
		|ПОМЕСТИТЬ ВТ_ИНН
		|ИЗ
		|	ВТ_ИНН_КПП КАК ВТ_ИНН_КПП
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Контрагенты.Ссылка,
		|	""Совпадает ИНН"",
		|	2,
		|	Контрагенты.Код
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.Ссылка <> &Ссылка
		|	И Контрагенты.ИНН = &ИНН
		|	И НЕ Контрагенты.Ссылка В
		|				(ВЫБРАТЬ
		|					ВТ_ИНН_КПП.НайденныйОбъект
		|				ИЗ
		|					ВТ_ИНН_КПП КАК ВТ_ИНН_КПП)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ИНН.НайденныйОбъект,
		|	ВТ_ИНН.Критерий,
		|	ВТ_ИНН.Порядок,
		|	ВТ_ИНН.Код
		|ИЗ
		|	ВТ_ИНН КАК ВТ_ИНН
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Контрагенты.Ссылка,
		|	""Совпадает наименование"",
		|	3,
		|	Контрагенты.Код
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.Ссылка <> &Ссылка
		|	И Контрагенты.Наименование = &Наименование
		|	И НЕ Контрагенты.Ссылка В
		|				(ВЫБРАТЬ
		|					ВТ_ИНН.НайденныйОбъект
		|				ИЗ
		|					ВТ_ИНН КАК ВТ_ИНН)";
		Запрос.УстановитьПараметр("Ссылка", ОбъектПроверки);
		Запрос.УстановитьПараметр("ИНН", ОбъектПроверки.ИНН);
		Запрос.УстановитьПараметр("КПП", ОбъектПроверки.КПП);
		Запрос.УстановитьПараметр("Наименование", ОбъектПроверки.Наименование);
		Выборка = Запрос.Выполнить().Выбрать();
	КонецЕсли;
	
	Пока Выборка.Следующий() Цикл
		//добавляем родителя
		ТекЭлемент = ЕстьЭлемент(ТаблицаПроверки.ПолучитьЭлементы(), Выборка.Критерий, 1);
		Если ТекЭлемент = Неопределено Тогда
			Раздел1 = ТаблицаПроверки.ПолучитьЭлементы().Добавить();
		Иначе
			Раздел1 = ТекЭлемент;
		КонецЕсли;
		Раздел1.Критерий 		= Выборка.Критерий;
		Раздел1.НайденныйОбъект = Выборка.Критерий;
		Раздел1.Иерархия = 1;
		
		
		//добавляем элемент
		ТекЭлемент = ЕстьЭлемент(Раздел1.ПолучитьЭлементы(), Выборка.НайденныйОбъект, 2);
		Если ТекЭлемент = Неопределено Тогда
			Раздел2 = Раздел1.ПолучитьЭлементы().Добавить();
		Иначе
			Раздел2 = ТекЭлемент;
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(Раздел2, Выборка);
		Раздел2.Иерархия = 2;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция ЕстьЭлемент(КоллекцияЭлементов, НаименованиеПункта, Иерархия)
	Для каждого ТекЭлемент Из КоллекцияЭлементов Цикл
		Если ?(Иерархия = 1, ТекЭлемент.Критерий, ТекЭлемент.НайденныйОбъект) = НаименованиеПункта Тогда
			Возврат ТекЭлемент;	
		КонецЕсли;	
	КонецЦикла; 
	Возврат Неопределено;	
КонецФункции 

&НаКлиенте
Процедура Проверить(Команда)
	
	ПроверитьНаСервере();
	
	Элементы.ТаблицаПроверки.Видимость = Истина;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РезультатСравненияКонтрагентаСГосРеестромНаСервере(Контрагент)

	ЭтоЮрЛицо = (Контрагент.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо Или Контрагент.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ПустаяСсылка());
	Если ЭтоЮрЛицо Тогда
		РеквизитыКонтрагента = ДанныеЕдиныхГосРеестров.РеквизитыЮридическогоЛицаПоИНН(Контрагент.ИНН);
	Иначе
		РеквизитыКонтрагента = ДанныеЕдиныхГосРеестров.РеквизитыПредпринимателяПоИНН(Контрагент.ИНН);
	КонецЕсли;
	
	ТабДок = новый ТабличныйДокумент;
	Макет = Справочники.Контрагенты.ПолучитьМакет("СравнениеРеквизитовСГосРеестром");
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьШапка.Параметры.ИНН = Контрагент.ИНН;
	ТабДок.Вывести(ОбластьШапка);
	
	ОбластьСтроки = Макет.ПолучитьОбласть("Строки");
	
	ОбластьСтроки.Параметры.Реквизит = "КПП";
	ОбластьСтроки.Параметры.ЗначениеВБазе = Контрагент.КПП;
	Попытка
		ОбластьСтроки.Параметры.ЗначениеВРеестре = РеквизитыКонтрагента.КПП;
	Исключение
		ОбластьСтроки.Параметры.ЗначениеВРеестре = "";
	КонецПопытки;
	Если ОбластьСтроки.Параметры.ЗначениеВБазе = ОбластьСтроки.Параметры.ЗначениеВРеестре Тогда
		ОбластьСтроки.Область("R1C4:R1C4").Картинка = БиблиотекаКартинок.ЗеленаяГалочка;
	Иначе
		ОбластьСтроки.Область("R1C4:R1C4").Картинка = БиблиотекаКартинок.Очистить;
	КонецЕсли;
	ТабДок.Вывести(ОбластьСтроки);
	
	ОбластьСтроки.Параметры.Реквизит = "Наименование";
	ОбластьСтроки.Параметры.ЗначениеВБазе = Контрагент.Наименование;
	ОбластьСтроки.Параметры.ЗначениеВРеестре = РеквизитыКонтрагента.Наименование;
	Если ОбластьСтроки.Параметры.ЗначениеВБазе = ОбластьСтроки.Параметры.ЗначениеВРеестре Тогда
		ОбластьСтроки.Область("R1C4:R1C4").Картинка = БиблиотекаКартинок.ЗеленаяГалочка;
	Иначе
		ОбластьСтроки.Область("R1C4:R1C4").Картинка = БиблиотекаКартинок.Очистить;
	КонецЕсли;
	ТабДок.Вывести(ОбластьСтроки);
	
	ОбластьСтроки.Параметры.Реквизит = "Наименование полное";
	ОбластьСтроки.Параметры.ЗначениеВБазе = Контрагент.НаименованиеПолное;
	ОбластьСтроки.Параметры.ЗначениеВРеестре = РеквизитыКонтрагента.НаименованиеСокращенное;
	Если ОбластьСтроки.Параметры.ЗначениеВБазе = ОбластьСтроки.Параметры.ЗначениеВРеестре Тогда
		ОбластьСтроки.Область("R1C4:R1C4").Картинка = БиблиотекаКартинок.ЗеленаяГалочка;
	Иначе
		ОбластьСтроки.Область("R1C4:R1C4").Картинка = БиблиотекаКартинок.Очистить;
	КонецЕсли;
	ТабДок.Вывести(ОбластьСтроки);
	
	ОбластьСтроки.Параметры.Реквизит = "Руководитель";
	ОбластьСтроки.Параметры.ЗначениеВБазе = Контрагент.Директор;
	Попытка
		ОбластьСтроки.Параметры.ЗначениеВРеестре = РеквизитыКонтрагента.Руководитель.Фамилия + " " + РеквизитыКонтрагента.Руководитель.Имя + " " + РеквизитыКонтрагента.Руководитель.Отчество;
	Исключение
		ОбластьСтроки.Параметры.ЗначениеВРеестре = "";
	КонецПопытки;
	Если ОбластьСтроки.Параметры.ЗначениеВБазе = ОбластьСтроки.Параметры.ЗначениеВРеестре Тогда
		ОбластьСтроки.Область("R1C4:R1C4").Картинка = БиблиотекаКартинок.ЗеленаяГалочка;
	Иначе
		ОбластьСтроки.Область("R1C4:R1C4").Картинка = БиблиотекаКартинок.Очистить;
	КонецЕсли;
	ТабДок.Вывести(ОбластьСтроки);
	
	ОбластьСтроки.Параметры.Реквизит = "Адрес";
	ОбластьСтроки.Параметры.ЗначениеВБазе = Контрагент.Адрес;
	Попытка
		ОбластьСтроки.Параметры.ЗначениеВРеестре = РеквизитыКонтрагента.ЮридическийАдрес.Представление;
	Исключение
		ОбластьСтроки.Параметры.ЗначениеВРеестре = "";
	КонецПопытки;
	Если ОбластьСтроки.Параметры.ЗначениеВБазе = ОбластьСтроки.Параметры.ЗначениеВРеестре Тогда
		ОбластьСтроки.Область("R1C4:R1C4").Картинка = БиблиотекаКартинок.ЗеленаяГалочка;
	Иначе
		ОбластьСтроки.Область("R1C4:R1C4").Картинка = БиблиотекаКартинок.Очистить;
	КонецЕсли;
	ТабДок.Вывести(ОбластьСтроки);
	
	Возврат ТабДок;
	
КонецФункции

&НаКлиенте
Процедура СравнитьКонтрагентаСГосРеестром(Команда)
	
	ТабДок = РезультатСравненияКонтрагентаСГосРеестромНаСервере(Задача.Заявка);
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Истина;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Истина;
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабДок.АвтоМасштаб = Истина;
	ФормаПечати = ПолучитьФорму("ОбщаяФорма.ФормаПечатиДокумента");
	ФормаПечати.Результат = ТабДок;
	ФормаПечати.Открыть();
	
КонецПроцедуры
