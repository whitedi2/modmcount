﻿
Процедура ОбработкаПроведения(Отказ, Режим)
		
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	//Если ЦФОвТЧ Тогда
	//	Для каждого ТекСтрока Из СЗ Цикл
	//		Если ТекСтрока.ЦФО.Пустая() Тогда
	//			Сообщить("В строке №" + ТекСтрока.НомерСтроки + " не указан ЦФО. Запись невозможна.");
	//			Отказ = Истина;			
	//		КонецЕсли;
	//	КонецЦикла; 
	//Иначе
	//	Если ЦФО.Пустая() Тогда
	//		Сообщить("Не указан ЦФО. Запись невозможна.");
	//		Отказ = Истина;			
	//	КонецЕсли; 
	//КонецЕсли;
	
	Если СостояниеДокумента = Перечисления.Д_СостоянияДокументов.Исполнен И ПометкаУдаления И НЕ ПараметрыСеанса.ТекущийПользователь.ПринадлежитЭлементу(Справочники.Пользователи.Администрирование) Тогда
		Сообщить("Невозможно пометить на удаление утвержденную служебную записку.");
		Отказ = Истина;
	КонецЕсли;
	
	Если ПометкаУдаления Тогда
		НаборЗаписейОтслеживания = РегистрыСведений.ОтслеживаниеЗаявок.СоздатьНаборЗаписей();
		НаборЗаписейОтслеживания.Отбор.Документ.Установить(Ссылка);
		НаборЗаписейОтслеживания.Прочитать();
		НаборЗаписейОтслеживания.Очистить();
		НаборЗаписейОтслеживания.Записать();
	КонецЕсли;	
	
	//Если Не Отказ Тогда
	//	Для Каждого СтрокаПриказы Из ЗамещенныеПриказы Цикл
	//		НеДействующийПриказ = СтрокаПриказы.Приказ.ПолучитьОбъект();
	//		НеДействующийПриказ.НеДействующий = Истина;
	//		НеДействующийПриказ.Записать();
	//	КонецЦикла;
	//КонецЕсли;
	
	РегистрыСведений.ВнутренниеДокументы.СоздатьЗаписьЖурнала(ЭтотОбъект);
	БПСервер.ДокументыСогласуемыеПриЗаписиОбработчик(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Доступность = Ложь;
	ЛимитВручную = Ложь;
	ТекущаяЗадача = "";
	ТекущийБизнесПроцесс = "";
	Файл = "";
	Автор = "";
	Контрагент = "";
	Номер = "";
	ДоступнаПользователям = Истина; //по просьбе ИТ
	
	//Если ВидСЗ = Справочники.Д_ВидыВнутреннихДокументов.СогласованиеУсловийКлиента Тогда
	//	Для каждого ТекСтрока Из УсловияКлиента Цикл
	//		
	//		ТекЗначения = БюджетныйНаСервере.ПолучитьТекущиеУсловияКонтрагента(ТекСтрока.Контрагент, ТекущаяДата());
	//		
	//		ЗаполнитьЗначенияСвойств(ТекСтрока, ТекЗначения);
	//		ТекСтрока.Дата = ТекущаяДата();
	//	КонецЦикла; 
	//	
	//	ДоговоренностиКлиента.Очистить();
	//	Запрос = Новый Запрос;
	//	Запрос.Текст = "ВЫБРАТЬ
	//	|	*
	//	|ИЗ
	//	|	РегистрСведений.КС_РеестрДоговоренностей.СрезПоследних(, Контрагент В (&Контрагенты)) КАК КС_РеестрДоговоренностейСрезПоследних";
	//	
	//	Запрос.УстановитьПараметр("Контрагенты", УсловияКлиента.ВыгрузитьКолонку("Контрагент"));
	//	
	//	Результат = Запрос.Выполнить();
	//	Выборка = Результат.Выбрать();
	//	
	//	Пока Выборка.Следующий() Цикл
	//		СтруктураПоиска = Новый Структура("Контрагент, Предприятие", Выборка.Контрагент, Выборка.Предприятие);
	//		Если НЕ ДоговоренностиКлиента.НайтиСтроки(СтруктураПоиска).Количество() Тогда
	//			НоваяСтрока = ДоговоренностиКлиента.Добавить();
	//			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	//			НоваяСтрока.Дата = ТекущаяДата();
	//			НоваяСтрока.ТекВерх = Выборка.Верх;
	//			НоваяСтрока.ТекЦена = Выборка.Цена;
	//		КонецЕсли;
	//	КонецЦикла;
	//
	//КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	//Если НЕ Ссылка.Пустая() Тогда
	//	БПСервер.ЗаполнитьТекБПиЗадачу(ЭтотОбъект);
	//КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;	
	КонецЕсли;
	
	Если ТипЗнч(Кому) = Тип("СправочникСсылка.Пользователи") Тогда
		Рецензенты.Очистить();
		НоваяСтрока = Рецензенты.Добавить();
		НоваяСтрока.Пользователь = Кому;
	КонецЕсли;
	
	//из подписки на событие
	БюджетныйНаСервере.ДокументыПередЗаписьюПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	БПСервер.ДокументыСогласуемыеПередЗаписьюПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	ВидСЗ = Справочники.Д_ВидыВнутреннихДокументов.ПолучитьЭлементПредопределенный("СлужебнаяЗаписка");

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если Предприятие.УчетПоПодразделениям И НЕ ЗначениеЗаполнено(Подразделение) Тогда
		сабОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(
		ЭтотОбъект,
		"Не указано подразделение.",
		,
		,
		"Подразделение",
		Отказ);
	КонецЕсли;
	
	//Для каждого ТекСтрока Из УсловияКлиента Цикл
	//	Родитель = ТекСтрока.Контрагент.Родитель;
	//	Если ЗначениеЗаполнено(Родитель) И Родитель.ГруппаКлиентов Тогда
	//		сабОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(
	//		ЭтотОбъект,
	//		"Контрагент """ + Строка(ТекСтрока.Контрагент) + """ входит в группу клиентов """ + Строка(Родитель) + """. Установка лимитов возможно только по группе.",
	//		"УсловияКлиента",
	//		ТекСтрока.НомерСтроки,
	//		"Контрагент",
	//		Отказ);
	//	КонецЕсли;
	//КонецЦикла; 
	
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	БюджетныйНаСервере.ПриУстановкеНовогоНомераПриУстановкеНовогоНомера(ЭтотОбъект, СтандартнаяОбработка, Префикс);
КонецПроцедуры



