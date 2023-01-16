﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	//ПараметрыФормы = Новый Структура("", );
		Если НЕ БПСервер.ТекПользовательИсполнительЗадачи(ПараметрКоманды) Тогда
			Предупреждение("Вы не являетесь исполнителем по данной задаче! Взять в работу невозможно!");
			Возврат;
		Иначе
			РеквизитыЗадачи = БюджетныйНаСервере.ВернутьРеквизиты(ПараметрКоманды[0], "ВРаботе");
			
			Если НЕ БюджетныйНаКлиенте.СогласоватьБизнесПроцесс(?(РеквизитыЗадачи.ВРаботе, "отложить", "взять в работу")) Тогда
				Возврат;
			КонецЕсли;
			УстановитьИЗакрыть(ПараметрКоманды, ПараметрыВыполненияКоманды);
			//ОткрытьФорму("Справочник.Задача.Форма.ФормаВзятияВРаботу", Новый Структура("Ключ", ПараметрКоманды)); 
		КонецЕсли;
	БПСервер.ЗаписатьДействиеПользователяВЛог(ПараметрКоманды, "ВзятьВРаботу");
	
	
	//ОткрытьФорму("Справочник.Задача.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры


&НаКлиенте
Процедура УстановитьИЗакрыть(ТекЗадачи, ПараметрыВыполненияКоманды)       //Русаков
	ТекПользователь = БюджетныйНаСервере.ПолучитьПользователя();
	
	Если ПараметрыВыполненияКоманды.Источник.Элементы.Найти("Комментарий") =Неопределено Тогда
		Комментарий = Строка(ТекПользователь) + " взял задачу в работу";
	Иначе
		Комментарий = ПараметрыВыполненияКоманды.Источник.Комментарий;
	КонецЕсли;
	
	Для Каждого ТекЗадача из ТекЗадачи Цикл 
		ТекРеквизиты = БюджетныйНаСервере.ВернутьРеквизиты(ТекЗадача, "БизнесПроцесс, Заявка, СрокВыполнения, ВРаботе, Описание, ДатаНачала, Заявка.Автор, БизнесПроцесс.Автор, ТочкаМаршрута"); 
		БизнесПроцесс = ТекРеквизиты.БизнесПроцесс;
		Заявка = ТекРеквизиты.Заявка;
		Описание = ТекРеквизиты.Описание;
		
		ВРаботе = 1 - ТекРеквизиты.ВРаботе;
		
		СрокВыполнения = ТекРеквизиты.СрокВыполнения;
		ДатаНачала = ТекРеквизиты.ДатаНачала;
		
		Если ЗначениеЗаполнено(БизнесПроцесс) Тогда
			ТекАвтор = ТекРеквизиты.БизнесПроцессАвтор;
			ТекЗаявка = БизнесПроцесс;
		Иначе
			ТекАвтор = ТекРеквизиты.ЗаявкаАвтор;
			ТекЗаявка = Заявка;
		КонецЕсли;
		
		Если ТипЗнч(БизнесПроцесс) = Тип("СправочникСсылка.СогласованиеОбщее") Тогда
			Если ТекРеквизиты.ТочкаМаршрута = ПредопределенноеЗначение("Перечисление.СогласованиеОбщееТочкиМаршрута.Действие3") Тогда
				ЗаписатьБизнесПроцесс(БизнесПроцесс, ВРаботе);
			КонецЕсли;	
		КонецЕсли;	
		
		ЗаписатьЗадачу(ТекЗадача, ВРаботе, ТекАвтор, Комментарий, Заявка);
		Оповестить("ОбновитьСписокЗадач");
		Оповестить("ЗакрытьФормуЗадачи");
		Если ЗначениеЗаполнено(Заявка) Тогда
			ОповеститьОбИзменении(Заявка);
		КонецЕсли;
		
	КонецЦикла;

	
	
	//КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьБизнесПроцесс(БизнесПроцесс, ВРаботе)
	БизнесПроцессОбъект = БизнесПроцесс.ПолучитьОбъект();
	ТекПользователи = БПСервер.ПолучитьМассивПользователей();
	Для каждого ТекПользователь Из ТекПользователи Цикл
		ОтобранныеСтроки = БизнесПроцессОбъект.ДопИсполнение.НайтиСтроки(Новый Структура("Исполнитель, Исполнено", ТекПользователь, Ложь));
		Для каждого ТекСтрока Из ОтобранныеСтроки Цикл
			ТекСтрока.ПринятоКИсполнению = ВРаботе;
			Прервать;	
		КонецЦикла;	
	КонецЦикла;
	БизнесПроцессОбъект.Записать();	
КонецПроцедуры


&НаСервере
Процедура ЗаписатьЗадачу(ТекЗадача, Вработе, ТекАвтор, Комментарий, Заявка)
	НачатьТранзакцию();
	
	Если ЗначениеЗаполнено(Заявка) Тогда
		ТекОб = ТекЗадача.Скопировать();
		ТекОб.Дата = ТекущаяДата();
		ТекОб.Наименование = СтрЗаменить(ТекОб.Наименование, "Принять к исполнению", "Исполнить");
		Если Вработе Тогда
			ТекОб.Исполнитель = ПараметрыСеанса.ТекущийПользователь;
		КонецЕсли;
	Иначе
		БПСервер.СтартоватьХронометражПоПредмету(ТекущаяДата(),ТекЗадача, ТекЗадача);
		ТекОб = ТекЗадача.ПолучитьОбъект();
	КонецЕсли;
	
	ТекОб.Вработе = Вработе;
	ТекОб.БизнесПроцесс = ТекЗадача.БизнесПроцесс;
	ТекОб.ТочкаМаршрута = ТекЗадача.ТочкаМаршрута;
	ТекОб.Записать();
	
	//записываем задание, присваиваем статус "ВРаботе"
	Если Вработе Тогда
		Если ТипЗнч(ТекЗадача.Заявка) = Тип("ДокументСсылка.БП_Поручение") Тогда
			ТекЗаявкаОбъект = ТекЗадача.Заявка.ПолучитьОбъект();
			СтруктураПоиска = Новый Структура("Исполнитель", ТекОб.Исполнитель);
			НайдденныеСтроки = ТекЗаявкаОбъект.СписокИсполнителей.НайтиСтроки(СтруктураПоиска);
			Для каждого ТекСтрока Из НайдденныеСтроки Цикл
				ТекСтрока.ВРаботе = Истина;
			КонецЦикла;
			ТекЗаявкаОбъект.Записать();
		КонецЕсли;
	КонецЕсли;
	Если ЗначениеЗаполнено(ТекЗадача.Заявка) Тогда
		БПСервер.ВыполнитьЗадачу(ТекЗадача, , Истина, ?(Вработе, "Взял(а) в работу.", "Отложил(а) выполнение"));
		БПСервер.СтартоватьХронометражПоПредмету(ТекущаяДата(),Заявка, Заявка);
	КонецЕсли;	
	//Если ПараметрыСеанса.ТекущийПользователь.ПолучатьУведомленияОСогласованииДокументов Тогда //если настроены доп уваедомления
		
		Если ВРаботе Тогда
			БПСервер.СоздатьОповещение(ТекАвтор, "Пользователь " + Строка(ПараметрыСеанса.ТекущийПользователь) + " взял в работу задачу """ + Строка(ТекЗадача) + """:
			|Комментарий: " + Строка(Комментарий), "Оповещение о взятии задачи в работу", Заявка, Истина, , ТекЗадача);
		Иначе
			БПСервер.СоздатьОповещение(ТекАвтор, "Пользователь " + Строка(ПараметрыСеанса.ТекущийПользователь) + " приостановил работу по задаче """ + Строка(ТекЗадача) + """:
			|Комментарий: " + Строка(Комментарий), "Оповещение о приостановке работы по задаче", Заявка, Истина, , ТекЗадача);
		КонецЕсли;
		
	//КонецЕсли;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры
