﻿&НаКлиенте
Процедура ДопСогласованиеПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	ТекСтрока = Элементы.ДопСогласование.ТекущиеДанные;
	ТекСтрока.Автор = БюджетныйНаСервере.ПолучитьПользователя();
КонецПроцедуры

&НаСервере
Процедура ДобавитьМаршрут(ВыбранныйМаршрут)
	
	Для каждого ТекСтрока Из ВыбранныйМаршрут.МаршрутЗаявки Цикл
		НоваяСтрока = Объект.ДопСогласование.Добавить();	
	    НоваяСтрока.Автор = БюджетныйНаСервере.ПолучитьПользователя();;
		Если ТипЗнч(ТекСтрока.СубъектСогласования) = Тип("СправочникСсылка.Пользователи") Тогда
			НоваяСтрока.СубъектСогласования = ТекСтрока.СубъектСогласования;
		Иначе
			Если ТекСтрока.СубъектСогласования = Справочники.Д_Должности.Директор ИЛИ ТекСтрока.СубъектСогласования = Справочники.Д_Должности.Дивизионер Тогда
				Если ТекСтрока.СубъектСогласования = Справочники.Д_Должности.Директор Тогда
					Должность = "Директор";
				Иначе
					Должность = "Дивизионер";				
				КонецЕсли;
				НоваяСтрока.СубъектСогласования = Объект.Предприятие[Должность];
				Если ПустаяСтрока(НоваяСтрока.СубъектСогласования) Тогда
					Объект.ДопСогласование.Удалить(НоваяСтрока);					
				КонецЕсли;
			КонецЕсли;			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
  
&НаКлиенте
Процедура Подбор(Команда)
	ВыбранныйМаршрут = ОткрытьФормуМодально("Справочник.Д_МаршрутыЗаявки.ФормаВыбора");
	МассивПользователей = ПолучитьПОьзователейМаршрута(ВыбранныйМаршрут);
	Если НЕ ВыбранныйМаршрут = Неопределено Тогда
		МассивПредприятий = Новый Массив;
		МассивПредприятий.Добавить(БюджетныйНаСервере.ВернутьРеквизиты(Объект.Заявка, "Предприятие").Предприятие);
		БюджетныйНаКлиенте.ДобавитьМаршрут(МассивПользователей, Объект.ДопСогласование, "СубъектСогласования", МассивПредприятий);	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьПОьзователейМаршрута(ВыбранныйМаршрут)

	Возврат ВыбранныйМаршрут.МаршрутЗаявки.ВыгрузитьКолонку("СубъектСогласования");	

КонецФункции // ()

&НаСервере
Функция ПроверитьНаличиеБП()
    Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СогласованиеОбщее.Ссылка
	|ИЗ
	|	Справочник.СогласованиеОбщее КАК СогласованиеОбщее
	|ГДЕ
	|	СогласованиеОбщее.Заявка = &Заявка";
	
	Запрос.УстановитьПараметр("Заявка", Объект.Заявка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Количество() Тогда
		Сообщить("По данному основанию уже есть запущеный бизнес-процесс. Старт невозможен.");
	КонецЕсли;
	Возврат Выборка.Количество();
КонецФункции // ()

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	//ОФК = ПолучитьОФК();
	//Если Объект.КонтрольСогласованияОФК И НЕ Объект.ДопСогласование.НайтиСтроки(Новый Структура("СубъектСогласования", ОФК)).Количество() Тогда
	//	НоваяСтрока = Объект.ДопСогласование.Добавить();
	//	НоваяСтрока.СубъектСогласования = ОФК;	
	//КонецЕсли;
	
	Если НЕ Объект.ДопСогласование.Количество() Тогда
		Если Вопрос("Не выбран маршрут! Служебная записка пойдет сразу на исполнение и ознакомление. Продолжить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет  Тогда
			Отказ = Истина;	
		Элементы.Группа2.ТекущаяСтраница = Элементы.Группа4;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	
	Если НЕ БюджетныйНаСервере.РольАдминаДоступнаСервер() Тогда
		Если ПроверитьНаличиеБП() Тогда
			Отказ = Истина;	
			Возврат;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ЗаписатьОснование(Объект.Заявка);
	Оповестить("ЗакрытьФорму", Новый Структура("ТекущийБизнесПроцесс", Объект.Ссылка) , ВладелецФормы);
	Оповестить("ОбновитьСписокЗадач");
	ОповеститьОбИзменении(Объект.Заявка);
КонецПроцедуры        

&НаСервереБезКонтекста
Процедура ЗаписатьОснование(ТекЗаявка)
	ТекЗаявкаОбъект = ТекЗаявка.ПолучитьОбъект();
	ТекЗаявкаОбъект.Записать();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	БюджетныйНаКлиенте.ФормаТолькоПросмотр(Объект, ЭтаФорма, Объект.Стартован, Истина);
	СтандартныйМаршрутПриИзменении(Неопределено);
	БюджетныйНаКлиенте.ПоказатьСтарыйМаршрут(Элементы, МаршрутЗаявкиОснования);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВИсполнение(Команда)
	Если Элементы.Группа2.ТекущаяСтраница = Элементы.Группа4 Тогда
		Для каждого ТекСтрока Из Элементы.ДопСогласование.ВыделенныеСтроки Цикл
			НоваяСтрока = Объект.ДопИсполнение.Добавить();
			НоваяСтрока.Исполнитель = Элементы.ДопСогласование.ДанныеСтроки(ТекСтрока).СубъектСогласования;
			Объект.ДопСогласование.Удалить(Объект.ДопСогласование.НайтиПоИдентификатору(ТекСтрока));
		КонецЦикла;
	ИначеЕсли Элементы.Группа2.ТекущаяСтраница = Элементы.Группа1 Тогда
		Для каждого ТекСтрока Из Элементы.ДопОповещение.ВыделенныеСтроки Цикл
			НоваяСтрока = Объект.ДопИсполнение.Добавить();
			НоваяСтрока.Исполнитель = Элементы.ДопОповещение.ДанныеСтроки(ТекСтрока).СубъектСогласования;
			Объект.Адресаты.Удалить(Объект.Адресаты.НайтиПоИдентификатору(ТекСтрока));
		КонецЦикла;
	КонецЕсли;	
КонецПроцедуры
	
&НаКлиенте
Процедура ПеренестиВСогласование(Команда)
	Если Элементы.Группа2.ТекущаяСтраница = Элементы.Группа8 Тогда
		Для каждого ТекСтрока Из Элементы.ДопИсполнение.ВыделенныеСтроки Цикл
			НоваяСтрока = Объект.ДопСогласование.Добавить();
			НоваяСтрока.СубъектСогласования = Элементы.ДопИсполнение.ДанныеСтроки(ТекСтрока).Исполнитель;
			Объект.ДопИсполнение.Удалить(Объект.ДопИсполнение.НайтиПоИдентификатору(ТекСтрока));
		КонецЦикла;
	ИначеЕсли Элементы.Группа2.ТекущаяСтраница = Элементы.Группа1 Тогда
		Для каждого ТекСтрока Из Элементы.ДопОповещение.ВыделенныеСтроки Цикл
			НоваяСтрока = Объект.ДопСогласование.Добавить();
			НоваяСтрока.СубъектСогласования = Элементы.ДопОповещение.ДанныеСтроки(ТекСтрока).СубъектСогласования;
			Объект.Адресаты.Удалить(Объект.Адресаты.НайтиПоИдентификатору(ТекСтрока));
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВОзнакомление(Команда)
	Если Элементы.Группа2.ТекущаяСтраница = Элементы.Группа4 Тогда
		Для каждого ТекСтрока Из Элементы.ДопСогласование.ВыделенныеСтроки Цикл
			НоваяСтрока = Объект.Адресаты.Добавить();
			НоваяСтрока.СубъектСогласования = Элементы.ДопСогласование.ДанныеСтроки(ТекСтрока).СубъектСогласования;
			Объект.ДопСогласование.Удалить(Объект.ДопСогласование.НайтиПоИдентификатору(ТекСтрока));
		КонецЦикла; 
	ИначеЕсли Элементы.Группа2.ТекущаяСтраница = Элементы.Группа8 Тогда	
		Для каждого ТекСтрока Из Элементы.ДопИсполнение.ВыделенныеСтроки Цикл
			НоваяСтрока = Объект.Адресаты.Добавить();
			НоваяСтрока.СубъектСогласования = Элементы.ДопИсполнение.ДанныеСтроки(ТекСтрока).Исполнитель;
			Объект.ДопИсполнение.Удалить(Объект.ДопИсполнение.НайтиПоИдентификатору(ТекСтрока));
		КонецЦикла; 
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПодборПользователя(Команда)
	
	//МассивПользователей = Новый Массив;
	//ИспользуемаяТЧ = Объект.Адресаты;
	//КоличествоПользователей = ИспользуемаяТЧ.Количество();
	//Для Индекс = 1 По КоличествоПользователей Цикл
	//	Если Не ИспользуемаяТЧ[КоличествоПользователей - Индекс].Согласовано И ЗначениеЗаполнено(ИспользуемаяТЧ[КоличествоПользователей - Индекс].СубъектСогласования) Тогда
	//		МассивПользователей.Добавить(ИспользуемаяТЧ[КоличествоПользователей - Индекс].СубъектСогласования);
	//		ИспользуемаяТЧ.Удалить(КоличествоПользователей - Индекс);
	//	КонецЕсли;
	//КонецЦикла;	
	//
	//КоличествоВМассиве = МассивПользователей.Количество();
	//ИндексВМассиве = КоличествоВМассиве;
	//Пока КоличествоВМассиве <> 0 Цикл
	//	ТекПользователь = МассивПользователей.Получить(ИндексВМассиве - 1);
	//	МассивПользователей.Вставить(ИндексВМассиве - КоличествоВМассиве, ТекПользователь);
	//	МассивПользователей.Удалить(ИндексВМассиве);
	//	КоличествоВМассиве = КоличествоВМассиве - 1;
	//КонецЦикла;	
	//
	//ПараметрыФормы = Новый Структура;
	//ПараметрыФормы.Вставить("МассивПользователей", МассивПользователей);
	//ПараметрЗакрытия = ОткрытьФормуМодально("Справочник.Пользователи.Форма.ФормаВыбораПодбор", ПараметрыФормы, Элементы.ДопОповещение); 
	//
	//Если ПараметрЗакрытия = "Отмена" ИЛИ ПараметрЗакрытия = Неопределено Тогда
	//	Для Каждого ТекПользователь Из МассивПользователей Цикл
	//		СтрокаАдресаты = Объект.Адресаты.Добавить();
	//		СтрокаАдресаты.СубъектСогласования = ТекПользователь;
	//	КонецЦикла;	
	//КонецЕсли;	
	
	ОткрытьФормумодально("Справочник.Пользователи.ФормаВыбора", Новый Структура("РежимВыбора, РасширенныйПодбор, ЗакрыватьПриВыборе", Истина, Истина, Ложь),Элементы.ДопОповещение);
		
КонецПроцедуры

&НаКлиенте
Процедура ДопСогласованиеПередУдалением(Элемент, Отказ)
			ТекСтрока = Элементы.ДопСогласование.ТекущиеДанные;
		Если ТекСтрока.Согласовано Тогда
			Предупреждение("Невозможно удалить строку, т.к. субъект " + Строка(ТекСтрока.СубъектСогласования) + " уже согласовал СЗ.");
			Отказ = Истина;
		ИначеЕсли НЕ ТекСтрока.Автор = БюджетныйНаСервере.ПолучитьПользователя() Тогда
			//Если ПустаяСтрока(ТекСтрока.Автор) Тогда
			//	Предупреждение("Невозможно удалить строку, т.к. тип СЗ требует согласование с указанным рецензентом.");		
			//Иначе
			//	Предупреждение("Невозможно удалить строку, т.к. ее добавил пользователь " + ТекСтрока.Автор  + ".");		
			//КонецЕсли;		
			//Отказ = Истина;
		КонецЕсли;
		
		Если ПолучитьОФК(Объект.Заявка) = Элемент.ТекущиеДанные.СубъектСогласования И Объект.КонтрольСогласованияОФК И Не РольАдминистратора() Тогда
		Сообщение = Новый СообщениеПользователю;
		//Если ТипЗнч(Объект.Заявка) = Тип("ДокументСсылка.Д_ЗаявкаНаОтгрузку") Тогда
		//	Сообщение.Текст = "Невозможно удалить контролера отгрузки из маршрута согласования!";
		//Иначе	
			Сообщение.Текст = "Невозможно удалить сотрудника ОФК из маршрута согласования!";
		//КонецЕсли;
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;	
		
КонецПроцедуры

&НаКлиенте
Процедура ДопСогласованиеПередНачаломИзменения(Элемент, Отказ)
	ТекСтрока = Элементы.ДопСогласование.ТекущиеДанные;
	Если ТекСтрока.Пройден ИЛИ НЕ ТекСтрока.Автор = БюджетныйНаСервере.ПолучитьПользователя() И НЕ ПустаяСтрока(ТекСтрока.СубъектСогласования) Тогда
		Предупреждение("Невозможно редактирование строки.");		
		Отказ = Истина;
	КонецЕсли;
	
	//Если Элемент.ТекущийЭлемент.Имя = "ДопСогласованиеРезультирующееСогласование"  Тогда
	//	Если НЕ УСУК(ТекСтрока.СубъектСогласования) Тогда
	//		Отказ = Истина;		
	//	КонецЕсли;
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДопСогласованиеСубъектСогласованияПриИзменении(Элемент)
	ТекПользователь = Элементы.ДопСогласование.ТекущиеДанные.СубъектСогласования;
	Если НЕ ПустаяСтрока(ТекПользователь) Тогда
		Элементы.ДопСогласование.ТекущиеДанные.РезультирующееСогласование = БюджетныйНаСервере.ВернутьРеквизит(ТекПользователь, "РезультирующееСогласование");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПодборПользователяСогл(Команда)
	ОткрытьФормумодально("Справочник.Пользователи.ФормаВыбора", Новый Структура("РежимВыбора, РасширенныйПодбор, ЗакрыватьПриВыборе", Истина, Истина, Ложь),Элементы.ДопСогласование); 
КонецПроцедуры

&НаКлиенте
Процедура ДопОповещениеСубъектСогласованияПриИзменении(Элемент)
	
	ОзнакомлениеАвтораПосле(Элемент.Родитель.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ДопОповещениеСразуПослеСтартаПриИзменении(Элемент)
	
	ОзнакомлениеАвтораПосле(Элемент.Родитель.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ОзнакомлениеАвтораПосле(ТекущаяСтрока)
	
	Если ТекущаяСтрока.СубъектСогласования = Объект.Автор Тогда
		ТекущаяСтрока.СразуПослеСтарта = Ложь;
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
КонецПроцедуры

&НаКлиенте
Процедура СтандартныйМаршрутПриИзменении(Элемент)
	Элементы.Группа2.ТолькоПросмотр = Объект.СтандартныйМаршрут;
	Элементы.Подбор.Доступность = НЕ Объект.СтандартныйМаршрут;
	Элементы.ДопОповещениеПодбор.Доступность = НЕ Объект.СтандартныйМаршрут;
	Если НЕ Объект.СтандартныйМаршрут Тогда
		Элементы.СтандартныйМаршрут.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьОФК(ТекЗаявка)
		
	Возврат Константы.СотрудникОФК.Получить();	

КонецФункции // ()

&НаСервереБезКонтекста
Функция РольАдминистратора()
	
	Возврат РольДоступна("Администратор");
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьМаршрутИзСтарого(Команда)
	
	Если ЗначениеЗаполнено(МаршрутЗаявкиОснования) Тогда
		Если Вопрос("Внимание! Данные текущего запроса будут заменены. Продолжить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
			ЗаполнитьМаршрутИзСтарогоСервер();
			СтандартныйМаршрутПриИзменении(Неопределено);
		КонецЕсли;
	Иначе
		Предупреждение("Не найден маршрут-основание!");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьМаршрутИзСтарогоСервер()
	
	Для каждого ТЧ Из МаршрутЗаявкиОснования.Метаданные().ТабличныеЧасти Цикл
		Объект[ТЧ.Имя].Очистить();
		Для каждого ТекСтрока Из МаршрутЗаявкиОснования[ТЧ.Имя] Цикл
			НоваяСтрока = Объект[ТЧ.Имя].Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			
			//боб1
			Если ТЧ.Имя = "ДопСогласование" Тогда
				НоваяСтрока.Согласовано = Ложь;
				НоваяСтрока.Пройден = Ложь;
				НоваяСтрока.Пользователь = "";
				НоваяСтрока.Комментарии = "";
				НоваяСтрока.Автор = ПараметрыСеанса.ТекущийПользователь;
				НоваяСтрока.ДатаВыполнения = Дата('00010101000000');
				НоваяСтрока.НомерИтерации = 0;
			КонецЕсли;
			
			//боб2
			Если ТЧ.Имя = "Адресаты" Тогда
				НоваяСтрока.Оповещен = Ложь;
				НоваяСтрока.НомерИтерации = 0;
			КонецЕсли;
			
		КонецЦикла; 
	КонецЦикла;
	Объект.СтандартныйМаршрут = Ложь;
	Объект.КонтрольСогласованияОФК = МаршрутЗаявкиОснования.КонтрольСогласованияОФК;
	
КонецПроцедуры


&НаКлиенте
Процедура ДопСогласованиеСубъектСогласованияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", Новый Структура("ПредприятиеДляКонтроля", Объект.Предприятие), Элемент);
КонецПроцедуры

