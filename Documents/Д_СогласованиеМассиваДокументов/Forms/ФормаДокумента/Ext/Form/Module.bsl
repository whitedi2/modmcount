﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекБП = БПСервер.НайтиТекущийБПСервер(Объект.Ссылка);
		Если НЕ ТекБП = Неопределено Тогда
			ТекБПСтруРекв = БюджетныйНаСервере.ВернутьРеквизиты(ТекБП, "ОснованиеЗаблокирован, Стартован, ОтправлятьВсем");
		КонецЕсли;
	Иначе
		ТекБП = Неопределено;
		ТекБПСтруРекв = Новый Структура;
		ВсемСразу = Неопределено;
	КонецЕсли;
	
	Если НЕ БюджетныйНаСервере.РольДоступнаСервер("Администратор") И НЕ ТекБП = Неопределено Тогда
		ТекДоступность = ТекБПСтруРекв.ОснованиеЗаблокирован;
		Если ТекДоступность = Неопределено Тогда
			ТекДоступность = ТекБПСтруРекв.Стартован;
		КонецЕсли;
		БюджетныйНаКлиенте.ФормаТолькоПросмотр(Объект, ЭтаФорма, ТекДоступность);
	КонецЕсли;	
		
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		Если ПустаяСтрока(Объект.Кому) Тогда
			Объект.Кому = Справочники.Пользователи.ПустаяСсылка();
		КонецЕсли;
		Объект.Дата = ТекущаяДата();
        Объект.Автор = ПараметрыСеанса.ТекущийПользователь;
		Объект.ВидСЗ = Справочники.Д_ВидыВнутреннихДокументов.НайтиПоНаименованию("Согласование начисления ЗП");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Предприятие", Объект.Предприятие);
	СтруктураПараметров.Вставить("Дата", ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДата()));
	Если ЗначениеЗаполнено(Объект.Кому) Тогда
		СтруктураПараметров.Вставить("Кому", Объект.Кому);
	КонецЕсли;	
	
	СтруктураОтбора = ОткрытьФормуМодально("Документ.Д_СогласованиеМассиваДокументов.Форма.ФормаЗаполнения", СтруктураПараметров, ЭтаФорма);
	
	Если Не СтруктураОтбора = Неопределено Тогда
		ЗаполнитьТаблицуДокументовНаСервере(СтруктураОтбора);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуДокументовНаСервере(СтруктураОтбора)
	
	Объект.ДокументыДляСогласования.Очистить();
	
	Если СтруктураОтбора.Сотрудники.Количество() = 0 Тогда
		ОтборПоСотрудникам = Ложь;
	Иначе
		ОтборПоСотрудникам = Истина;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Д_СогласованиеМассиваДокументовДокументыДляСогласования.Документ
	|ПОМЕСТИТЬ ВТ_ДокументыСогласованияМассиваДокументов
	|ИЗ
	|	Документ.Д_СогласованиеМассиваДокументов.ДокументыДляСогласования КАК Д_СогласованиеМассиваДокументовДокументыДляСогласования
	|ГДЕ
	|	НЕ Д_СогласованиеМассиваДокументовДокументыДляСогласования.Ссылка.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РуководителиСтруктурныхПодразделений.Подразделение
	|ПОМЕСТИТЬ Вт_Подразделения
	|ИЗ
	|	РегистрСведений.РуководителиСтруктурныхПодразделений КАК РуководителиСтруктурныхПодразделений
	|ГДЕ
	|	(&РуководительСтруктурногоПодразделения = ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка)
	|			ИЛИ РуководителиСтруктурныхПодразделений.Руководитель = &РуководительСтруктурногоПодразделения)
	|	И (&СтруктурноеПодразделение = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|			ИЛИ РуководителиСтруктурныхПодразделений.Подразделение = &СтруктурноеПодразделение)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УЧ_НачислениеЗПТабличнаяЧасть.Ссылка КАК Документ
	|ИЗ
	|	Вт_Подразделения КАК Вт_Подразделения
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.УЧ_НачислениеЗП.ТабличнаяЧасть КАК УЧ_НачислениеЗПТабличнаяЧасть
	|		ПО Вт_Подразделения.Подразделение = УЧ_НачислениеЗПТабличнаяЧасть.Подразделение
	|ГДЕ
	|	УЧ_НачислениеЗПТабличнаяЧасть.Ссылка.Дата >= &ДатаНач
	|	И УЧ_НачислениеЗПТабличнаяЧасть.Ссылка.Дата <= &ДатаКон
	|	И ВЫБОР
	|			КОГДА &ОтборПоСотрудникам
	|				ТОГДА УЧ_НачислениеЗПТабличнаяЧасть.Сотрудник В (&Сотрудники)
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|	И УЧ_НачислениеЗПТабличнаяЧасть.Ссылка.Проведен
	|	И НЕ УЧ_НачислениеЗПТабличнаяЧасть.Ссылка В
	|				(ВЫБРАТЬ
	|					ВТ_ДокументыСогласованияМассиваДокументов.Документ
	|				ИЗ
	|					ВТ_ДокументыСогласованияМассиваДокументов КАК ВТ_ДокументыСогласованияМассиваДокументов)
	|
	|СГРУППИРОВАТЬ ПО
	|	УЧ_НачислениеЗПТабличнаяЧасть.Ссылка";
	Запрос.УстановитьПараметр("ДатаНач", СтруктураОтбора.ДатаНач);
	Запрос.УстановитьПараметр("ДатаКон", СтруктураОтбора.ДатаКон);
	Запрос.УстановитьПараметр("Сотрудники", СтруктураОтбора.Сотрудники);
	Запрос.УстановитьПараметр("ОтборПоСотрудникам", ОтборПоСотрудникам);
	Запрос.УстановитьПараметр("СтруктурноеПодразделение", СтруктураОтбора.СтруктурноеПодразделение);
	Запрос.УстановитьПараметр("РуководительСтруктурногоПодразделения", СтруктураОтбора.РуководительСтруктурногоПодразделения);
	
	Объект.ДокументыДляСогласования.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры	

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗакрытьФорму" Тогда
		ЭтаФорма.Закрыть();
	ИначеЕсли ИмяСобытия = "Пересчитать" Тогда
		Закрыть();
	ИначеЕсли ИмяСобытия = "ПрикрепленныеФайлы" Тогда	
		сабОбщегоНазначенияКлиент.ОбновитьКоличествоПрикрепленныхФайлов(ЭтаФорма);
	ИначеЕсли ИмяСобытия = "РазрешитьРедактированиеФормы" Тогда	
		ПриОткрытии(Ложь);
	КонецЕсли;
	
КонецПроцедуры
