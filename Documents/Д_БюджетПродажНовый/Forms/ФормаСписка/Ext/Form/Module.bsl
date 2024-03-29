﻿&НаСервере
Процедура ОбновитьТЧСервер(ТекДокумент)
	СписокБП.Параметры.УстановитьЗначениеПараметра("Заявка", ТекДокумент);
КонецПроцедуры

&НаСервере
Функция КоличМесяцев(ТекДокумент)
	ДатаНачала = НачалоМесяца(ТекДокумент.Сценарий.ДатаНачала + 60 * 60 * 24);
	ДатаОкончания = КонецМесяца(ТекДокумент.Сценарий.ДатаКонца);
	ТекДата = ДатаНачала;
	КоличествоМесяцевДо = 0;
	Пока ТекДата <= ДатаОкончания Цикл
		КоличествоМесяцевДо = КоличествоМесяцевДо + 1;
		ТекДата = ДобавитьМесяц(ТекДата, 1);
	КонецЦикла;
	
	Возврат КоличествоМесяцевДо;
КонецФункции // ()



&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Если НЕ Элементы.Список.ТекущиеДанные = Неопределено Тогда
	
	ВсяВидимость = БюджетныйНаСервере.РольДоступнаСервер("БюджетныйОтдел") ИЛИ БюджетныйНаСервере.РольДоступнаСервер("Администратор");
	Авторы = БПСервер.ПолучитьМассивПользователей();
	
	СписокБП.Параметры.УстановитьЗначениеПараметра("Заявка", Элементы.Список.ТекущаяСтрока);
	СписокБП.Параметры.УстановитьЗначениеПараметра("Автор", Авторы);
	СписокБП.Параметры.УстановитьЗначениеПараметра("ВсяВидимость", ВсяВидимость);
	
	Список.Параметры.УстановитьЗначениеПараметра("БюджетнаяРоль", БюджетныйНаСервере.ВернутьРеквизит(БюджетныйНаСервере.ПолучитьПользователя(), "БюджетнаяРоль"));
	Список.Параметры.УстановитьЗначениеПараметра("ВсяВидимость", ВсяВидимость);
	Список.Параметры.УстановитьЗначениеПараметра("Автор", Авторы);
	//КонецЕсли;
КонецПроцедуры


&НаСервере
Функция ПолучитьБП(ТекЗаявка)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	УтверждениеБюджета.ТипБюджета
	               |ИЗ
	               |	БизнесПроцесс.УтверждениеБюджета КАК УтверждениеБюджета
	               |ГДЕ
	               |	УтверждениеБюджета.Заявка = &Заявка
	               |	И УтверждениеБюджета.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("Заявка", ТекЗаявка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	МассивБП = Новый Массив;
	Пока Выборка.Следующий() Цикл
		МассивБП.Добавить(Выборка.ТипБюджета.Метаданные().ЗначенияПеречисления[Перечисления.Д_ТипыБюджетов.Индекс(Выборка.ТипБюджета)].Имя);
	КонецЦикла;
	Возврат МассивБП;
КонецФункции // ()

&НаКлиенте
Процедура СписокБПВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ТабДок = Новый ТабличныйДокумент;
	
	Печать(ТабДок, Элементы.Список.ТекущаяСтрока, Элементы.СписокБП.ТекущаяСтрока);
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Истина;
	ТабДок.ОтображатьГруппировки = Истина;
	ФормаПечати = ПолучитьФорму("Документ.Д_Бюджет.Форма.ФормаПечатиЗатрат");
	ФормаПечати.ТабДок = ТабДок;
	ФормаПечати.Открыть();
	
КонецПроцедуры

&НаСервере
Процедура Печать(ТабДок, ПараметрКоманды, ТипБюджета)
	Если ТипБюджета.ТипБюджета = Перечисления.Д_ТипыБюджетов.БюджетЗатрат Тогда
		Документы.Д_Бюджет.РечатьСебестоимостьСервер(ТабДок, ПараметрКоманды, ТипБюджета.ТипБюджета);
	ИначеЕсли ТипБюджета.ТипБюджета = Перечисления.Д_ТипыБюджетов.БюджетЗакупок Тогда 
		Документы.Д_Бюджет.РассчитатьСырье(ТабДок, ПараметрКоманды, ТипБюджета.ТипБюджета);	
	ИначеЕсли ТипБюджета.ТипБюджета = Перечисления.Д_ТипыБюджетов.БюджетИнвестиций Тогда 
		Документы.Д_Бюджет.РассчитатьИнвестиции(ТабДок, ПараметрКоманды, ТипБюджета.ТипБюджета);
	ИначеЕсли ТипБюджета.ТипБюджета = Перечисления.Д_ТипыБюджетов.БюджетПродаж Тогда 
		Документы.Д_Бюджет.РасчитатьПродажи(ТабДок, ПараметрКоманды, ТипБюджета.ТипБюджета);
	ИначеЕсли ТипБюджета.ТипБюджета = Перечисления.Д_ТипыБюджетов.КорректировкиБюджета Тогда 
		Документы.Д_Бюджет.ПечатьКорректировки(ТабДок, ПараметрКоманды, ТипБюджета.ТипБюджета);	
	КонецЕсли;
	
КонецПроцедуры



