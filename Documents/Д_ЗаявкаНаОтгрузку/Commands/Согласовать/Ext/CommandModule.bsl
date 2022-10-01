﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	БП = БПСервер.ПоискБП("СогласованиеОбщее", ПараметрКоманды);
	Если НЕ БП = Неопределено Тогда
		Если БюджетныйНаСервере.ВернутьРеквизит(БП, "Стартован") Тогда
			Если НЕ БюджетныйНаСервере.ВернутьРеквизит(БП, "ОснованиеЗаблокирован") Тогда
				ОткрытьФорму("БизнесПроцесс.СогласованиеОбщее.ФормаОбъекта", Новый Структура("Ключ", БП)); 
				Возврат;
			Иначе	
				Предупреждение("Бизнес-процесс согласования уже запущен.");
				Возврат;		
			КонецЕсли;
		Иначе
			ОткрытьФорму(БПСервер.ПолучитьПолноеИмяФормы(БП), Новый Структура("Ключ", БП));
			Возврат;
		КонецЕсли;	
	КонецЕсли;
	
	
	Если Вопрос("После старта процесса согласования изменения в документе станут невозможны. Уверены что хотите стартовать бизнес процесс?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
		
		ТекФормаБП = ПолучитьФорму("БизнесПроцесс.СогласованиеОбщее.Форма.ФормаНовый");
		ТекФормаБП.Объект.Автор = БюджетныйНаСервере.ПолучитьПользователя();
		ТекФормаБП.Объект.Описание = БюджетныйНаСервере.ВернутьРеквизит(ПараметрКоманды, "Комментарий");
		ТекФормаБП.Объект.Заявка = ПараметрКоманды;
		ТекФормаБП.Объект.КонтрольСогласованияОФК = Истина;
		ТекФормаБП.Объект.СтандартныйМаршрут = Истина;
		ТекФормаБП.Элементы.КонтрольСогласованияОФК.Доступность = Ложь;
		ТекФормаБП.Объект.ОснованиеЗаблокирован = Истина;
		ТекФормаБП.ВладелецФормы = ПараметрыВыполненияКоманды.Источник;
		//ТекФормаБП.Элементы.Исполнение.Видимость = Ложь;
		//частные случаи, автозаполнение маршрута
		Если ПроверитьУчетчикаНаСервере(ПараметрКоманды) Тогда
			Предупреждение("Не возможно запустить бизнес-процесс, так как не назначен учетчик предприятия: " + БюджетныйНаСервере.ВернутьРеквизит(ПараметрКоманды, "Предприятие") + ". Обратитесь в учетную службу, либо к администратору!");
			Возврат;
		КонецЕсли;	
		ДанныеФормы = ТекФормаБП.Объект;
		ЗаполнитьНаСервере(ДанныеФормы, ПараметрКоманды);
		КопироватьДанныеФормы(ДанныеФормы, ТекФормаБП.Объект);
		ТекФормаБП.Открыть();
		
		
		//ПоказатьОповещениеПользователя("Запущен бизнес процесс согласования:",
		//,
		//ПараметрКоманды,
		//БиблиотекаКартинок.БизнесПроцесс);
		//ОповеститьОбИзменении(ПараметрКоманды);
	КонецЕсли;

КонецПроцедуры


&НаСервере
Процедура ЗаполнитьНаСервере(ТекОбъект, ТекОснование)
	// !!!!!!!!!!!!!!!!!!!!!!!!! в случае редактирования модуля не забыть продублировать изменения в форме БизнесПроцесс.СогласованиеОбщий.ФормаПодготовкм
	
	//создаем маршрут согласования
	ТипВодочная = (НЕ ТекОснование.ТипЗаявки = "Водочная");
	Двоечка = (ТекОснование.ТипРеализации = "Спирт№2");
	
	//учетчика ОТК в начало маршрута по просьбе ВИП
	Если Двоечка Тогда
		ДобавитьСтрокуДопСогласование(ТекОбъект, БПСервер.ПолучитьСотрудникаПоОсновнойДолжности(ТекОснование.Предприятие, Перечисления.ОсновныеДолжностиПредприятия.Учетчик), "Учетчик предприятия-производителя", Истина);//по Обращение в техподдержку 1С 00000000836 от 22.03.2013 16:15:41
		ДобавитьСтрокуДопСогласование(ТекОбъект, БПСервер.ПолучитьСотрудникаПоОсновнойДолжности(ТекОснование.Док, Перечисления.ОсновныеДолжностиПредприятия.Учетчик), "Учетчик предприятия-грузоотправителя", Истина);// добавляем учетчика по №2
		//ДобавитьСтрокуДопСогласование(ТекОбъект, Константы.БП_УчетчикОТК.Получить(), "Учетчик ОТК", ТипВодочная); //по обращению Обращение в техподдержку 1С 00000002049 от 15.01.2014 13:33:17
		ДобавитьСтрокуДопСогласование(ТекОбъект, Константы.БП_ОтветственныйОтгрузки2.Получить(), "Ответственный за отгрузки №2", ТипВодочная);
	Иначе
		ДобавитьСтрокуДопСогласование(ТекОбъект, БПСервер.ПолучитьСотрудникаПоОсновнойДолжности(ТекОснование.Предприятие, Перечисления.ОсновныеДолжностиПредприятия.Учетчик), "Учетчик предприятия-производителя", Истина);//по Обращение в техподдержку 1С 00000000836 от 22.03.2013 16:15:41
		//ДобавитьСтрокуДопСогласование(ТекОбъект, Константы.БП_УчетчикОТК.Получить(), "Учетчик ОТК", ТипВодочная);
	КонецЕсли;
	
	//ДобавитьСтрокуДопСогласование(ТекОбъект, Константы.БП_ОтветственныйЗаГрафик.Получить(), "Ответственный за отгрузки №1", ТипВодочная);
	
	//комдиректор
	//ДобавитьСтрокуДопСогласование(ТекОбъект, БПСервер.ПолучитьКомДираСервер(ТекОснование.ДатаОтгрузки, ТекОснование.Грузополучатель), "Коммерческий директор", ТипВодочная);
	
	//в случае №2 руководитель див №2
	Если ТекОснование.ТипРеализации = "Спирт№2" Тогда
		ДобавитьСтрокуДопСогласование(ТекОбъект, БПСервер.ПолучитьСотрудникаПоОсновнойДолжности(ТекОснование.Док, Перечисления.ОсновныеДолжностиПредприятия.Дивизионер), "Руководитель див 3", ТипВодочная);
	КонецЕсли;
	
	//руководитель службы
	//ДобавитьСтрокуДопСогласование(ТекОбъект, Константы.БП_РуководительКС.Получить(), "Руководитель службы", ТипВодочная);
	
	//ответвенный водка
	//ДобавитьСтрокуДопСогласование(ТекОбъект, Константы.БП_БухгалтерВодка.Получить(), "Руководитель службы", ТекОснование.ТипЗаявки = "Водочная");
	
	//ОФК
	//Если ТекущаяДата()>=Дата("20111230") И  ТекущаяДата()<=Дата("20120109235959") Тогда
	//Иначе
	//	ДобавитьСтрокуДопСогласование(ТекОбъект, Константы.БП_КонтролерОтгрузки.Получить(), "Контролер отгрузки", Истина);  
	//КонецЕсли;
	
	
	//создаем список исполнения производитель 1
	ДобавитьСтрокуДопИсполнение(ТекОбъект, БПСервер.ПолучитьСотрудникаПоОсновнойДолжности(ТекОснование.Предприятие, Перечисления.ОсновныеДолжностиПредприятия.РуководительПроекта), "Директор произв. 1", Истина, "Обеспечить огрузку", ТекОснование.Предприятие);
	
	//создаем список исполнения производитель 2
	Если ТекОснование.Количество2 Тогда
		ДобавитьСтрокуДопИсполнение(ТекОбъект, БПСервер.ПолучитьСотрудникаПоОсновнойДолжности(ТекОснование.Предприятие2, Перечисления.ОсновныеДолжностиПредприятия.РуководительПроекта), "Директор произв. 2", Истина, "Обеспечить огрузку", ТекОснование.Предприятие2);
	КонецЕсли;
	//создаем список исполнения
	Если ТекОснование.ТипРеализации = "Спирт№2ПодДоки" Тогда
		ДобавитьСтрокуДопИсполнение(ТекОбъект, БПСервер.ПолучитьСотрудникаПоОсновнойДолжности(ТекОснование.Док, Перечисления.ОсновныеДолжностиПредприятия.РуководительПроекта), "Директор предприятия(чьи доки)", Истина, "Обеспечить огрузку доками", ТекОснование.Предприятие);
	КонецЕсли;
	
	//добавить исполнителя доставки
	Если ТекОснование.АвтоДоставка Тогда
		ДобавитьСтрокуДопИсполнение(ТекОбъект, БПСервер.ПолучитьСотрудникаПоОсновнойДолжности(ТекОснование.Предприятие, Перечисления.ОсновныеДолжностиПредприятия.Логист), "Доставка произв. 1", Истина, "Подать автотранспорт", ТекОснование.Предприятие, Ложь);
	КонецЕсли;
	Если ЗначениеЗаполнено(ТекОснование.Предприятие2) И ТекОснование.АвтоДоставка2 Тогда
		ДобавитьСтрокуДопИсполнение(ТекОбъект, БПСервер.ПолучитьСотрудникаПоОсновнойДолжности(ТекОснование.Предприятие2, Перечисления.ОсновныеДолжностиПредприятия.Логист),  "Доставка произв. 2", Истина, "Подать автотранспорт", ТекОснование.Предприятие2, Ложь);
	КонецЕсли;
	
	//добавляем ответсвенного ЖД
	//Если ТекОснование.ЖДДоставкаДоки Тогда
	//	ДобавитьСтрокуДопИсполнение(ТекОбъект, Константы.БП_ОтветственныйЗаЖДДоставку.Получить(), "Жд доставка", Истина, "Подать жд вагоны");
	//КонецЕсли;
	
	
	//добавляем ответсвенного РАР
	//Если ТекОснование.АвтоДоставкаДоки И НЕ ТекОснование.ТипРеализации = "Спирт№2" Тогда
	//	ДобавитьСтрокуДопИсполнение(ТекОбъект, Константы.ОтветственныйРАР.Получить(), "Ответственный за оповещение РАР по доставке", Истина, "Подготовить уведомление РАР");
	//КонецЕсли;
	
	// 23.01.13 добавляем зав. лабораторией
	ДобавитьСтрокуДопИсполнение(ТекОбъект, БПСервер.ПолучитьСотрудникаПоОсновнойДолжности(ТекОснование.Предприятие, Перечисления.ОсновныеДолжностиПредприятия.ЗавЛабораторией), "Зав. лабораторией произв. 1", Истина, "Ввести документ фактической отгрузки", ТекОснование.Предприятие);
	Если ТекОснование.Количество2 Тогда
		ДобавитьСтрокуДопИсполнение(ТекОбъект, БПСервер.ПолучитьСотрудникаПоОсновнойДолжности(ТекОснование.Предприятие2, Перечисления.ОсновныеДолжностиПредприятия.ЗавЛабораторией), "Зав. лабораторией произв. 2", Истина, "Ввести документ фактической отгрузки", ТекОснование.Предприятие2);
	КонецЕсли;
	//добавляем Учетчик производителя
	
	//добавляем в ознакомление директора доков (предварительно)
	Если ТекОснование.ТипРеализации = "Спирт№2ПодДоки" Тогда
		ДобавитьСтрокуДопОзнакомление(ТекОбъект, БПСервер.ПолучитьСотрудникаПоОсновнойДолжности(ТекОснование.Док, Перечисления.ОсновныеДолжностиПредприятия.РуководительПроекта), "Директор предприятия (чьи доки)", Истина, Истина);
		ДобавитьСтрокуДопОзнакомление(ТекОбъект, БПСервер.ПолучитьСотрудникаПоОсновнойДолжности(ТекОснование.Док, Перечисления.ОсновныеДолжностиПредприятия.Учетчик), "Учетчик предприятия (чьи доки)", Истина);
	ИначеЕсли ТекОснование.ТипРеализации = "Спирт№2" Тогда
		//ДобавитьСтрокуДопОзнакомление(ТекОбъект, БПСервер.ПолучитьСотрудникаПоОсновнойДолжности(ТекОснование.Док, Перечисления.ОсновныеДолжностиПредприятия.Дивизионер, ТекущаяДата()), "Руководитель див 3", Истина, Истина);
	КонецЕсли;
	
	//добавляем Учетчик производителя 1
	ДобавитьСтрокуДопОзнакомление(ТекОбъект, БПСервер.ПолучитьСотрудникаПоОсновнойДолжности(ТекОснование.Предприятие, Перечисления.ОсновныеДолжностиПредприятия.Учетчик), "Учетчик произв. 1", Истина);
	//добавляем Учетчик производителя 2
	Если ТекОснование.Количество2 Тогда
		ДобавитьСтрокуДопОзнакомление(ТекОбъект, БПСервер.ПолучитьСотрудникаПоОсновнойДолжности(ТекОснование.Предприятие2, Перечисления.ОсновныеДолжностиПредприятия.Учетчик), "Учетчик произв. 2", Истина);
	КонецЕсли;
	
	БПСервер.ДобавитьРецензентовВМаршрут(ТекОбъект, "ДопСогласование", ТекОснование.Ссылка, ТекОснование.Предприятие, ТекОснование.Дата);
	БПСервер.ДобавитьРецензентовВМаршрут(ТекОбъект, "ДопИсполнение", ТекОснование.Ссылка, ТекОснование.Предприятие, ТекОснование.Дата);
	БПСервер.ДобавитьРецензентовВМаршрут(ТекОбъект, "ДопОповещение", ТекОснование.Ссылка, ТекОснование.Предприятие, ТекОснование.Дата);
	
	//Добавляем Татьяну в ознакомлене. Она хочет проверять цены
	//ДобавитьСтрокуДопОзнакомление(ТекОбъект, Справочники.Пользователи.НайтиПоНаименованию("Андрианова Т"), "Финансист ОТК2", Истина, Истина);
	//ДобавитьСтрокуДопОзнакомление(ТекОбъект, Справочники.Пользователи.НайтиПоНаименованию("Нетесова О"), "Финансист Спецтранс О", Истина, Истина);
	//ДобавитьСтрокуДопОзнакомление(ТекОбъект, Справочники.Пользователи.НайтиПоНаименованию("Финансист ОТК"), "Финансист ОТК", Истина, Истина);
	//добавляем ВИП по обращению Обращение в техподдержку 1С 00000001273 от 16.07.2013 16:21:32
	//ДобавитьСтрокуДопОзнакомление(ТекОбъект, Справочники.Пользователи.НайтиПоНаименованию("ВИП", Истина), "Руководитель ОТК", Истина, Истина);
	
	ОбновитьEmailРассылку(ТекОбъект, ТекОснование); 
КонецПроцедуры

&НаСервере
Процедура ОбновитьEmailРассылку(ТекОбъект, ТекОснование)
	ТекОбъект.ДопРассылка.Очистить();
	Для каждого ТекРеспондент Из ТекОснование.Предприятие.ДопСписокРеспондентов Цикл
		Если НЕ ТекОбъект.ДопРассылка.НайтиСтроки(Новый Структура("EMail", ТекРеспондент.EMail)).Количество() Тогда
			Если ТекРеспондент.Признак = "КС" Тогда
				НоваяСтрока = ТекОбъект.ДопРассылка.Добавить();
				НоваяСтрока.EMail = ТекРеспондент.EMail;			
				НоваяСтрока.РольПользователя = ТекРеспондент.Комментарии;
				НоваяСтрока.ПослеСогласования = Истина;
			КонецЕсли;		
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ТекРеспондент Из ТекОснование.Док.ДопСписокРеспондентов Цикл
		Если НЕ ТекОбъект.ДопРассылка.НайтиСтроки(Новый Структура("EMail", ТекРеспондент.EMail)).Количество() Тогда
			Если ТекРеспондент.Признак = "КС" Тогда
				НоваяСтрока = ТекОбъект.ДопРассылка.Добавить();
				НоваяСтрока.EMail = ТекРеспондент.EMail;			
				НоваяСтрока.РольПользователя = ТекРеспондент.Комментарии;
				НоваяСтрока.ПослеСогласования = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ТекРеспондент Из ТекОснование.ДокиНаПровоз.ДопСписокРеспондентов Цикл
		Если НЕ ТекОбъект.ДопРассылка.НайтиСтроки(Новый Структура("EMail", ТекРеспондент.EMail)).Количество() Тогда
			Если ТекРеспондент.Признак = "КС" Тогда
				НоваяСтрока = ТекОбъект.ДопРассылка.Добавить();
				НоваяСтрока.EMail = ТекРеспондент.EMail;			
				НоваяСтрока.РольПользователя = ТекРеспондент.Комментарии;
				НоваяСтрока.ПослеСогласования = Истина;
			КонецЕсли;
		КонецЕсли
	КонецЦикла;
КонецПроцедуры


&НаСервере
Процедура ДобавитьСтрокуДопСогласование(ТекОбъект, ТекПользователь, РольПользователя, Добавлять)

	Если Не ПустаяСтрока(ТекПользователь) И Добавлять Тогда
		ОтобранныеСтроки = ТекОбъект.ДопСогласование.НайтиСтроки(Новый Структура("СубъектСогласования", ТекПользователь));
		Если НЕ ОтобранныеСтроки.Количество() Тогда
			НоваяСтрока = ТекОбъект.ДопСогласование.Добавить();
			НоваяСтрока.СубъектСогласования = ТекПользователь;
			НоваяСтрока.РольПользователя = РольПользователя;
		КонецЕсли;
	КонецЕсли;
	

КонецПроцедуры

&НаСервере
Процедура ДобавитьСтрокуДопОзнакомление(ТекОбъект, ТекПользователь, РольПользователя, Водочная = Истина, СразуПослеСтарта = Ложь)
	
	Если Не ПустаяСтрока(ТекПользователь) И Водочная Тогда
		ОтобранныеСтроки = ТекОбъект.ДопОповещение.НайтиСтроки(Новый Структура("Пользователь", ТекПользователь));
		Если НЕ ОтобранныеСтроки.Количество() Тогда
			НоваяСтрока = ТекОбъект.ДопОповещение.Добавить();
			НоваяСтрока.Пользователь = ТекПользователь;
			НоваяСтрока.РольПользователя = РольПользователя;
			НоваяСтрока.СразуПослеСтарта = СразуПослеСтарта;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтрокуДопИсполнение(ТекОбъект, ТекПользователь, РольПользователя, ПерсональнаяЗаявка, НаименованиеЗадачи = "", Предприятие = "", ПроверятьУникальность = Истина)

	Если Не ПустаяСтрока(ТекПользователь) Тогда
		ОтобранныеСтроки = ТекОбъект.ДопИсполнение.НайтиСтроки(Новый Структура("Исполнитель", ТекПользователь));
		Если НЕ ОтобранныеСтроки.Количество() ИЛИ НЕ ПроверятьУникальность Тогда
			НоваяСтрока = ТекОбъект.ДопИсполнение.Добавить();
			НоваяСтрока.Исполнитель = ТекПользователь;
			НоваяСтрока.РольПользователя = РольПользователя;
			НоваяСтрока.НаименованиеЗадачи = НаименованиеЗадачи;
			НоваяСтрока.Предприятие = Предприятие;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Функция ПроверитьУчетчикаНаСервере(ТекОснование)
    //Проверим установлен ли учетчик у предприятия
	Возврат БПСервер.ПолучитьСотрудникаПоОсновнойДолжности(ТекОснование.Предприятие, Перечисления.ОсновныеДолжностиПредприятия.Учетчик).Пустая();
	
КонецФункции

