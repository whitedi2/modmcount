﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ЗадачаОбъект.Задача") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения, "Заявка, Предприятие");
		Дата = ТекущаяДата();
		ДатаНачала = ТекущаяДата();
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Проекты") Тогда
		Дата = ТекущаяДата();
		ДатаНачала = ТекущаяДата();
		Проект = ДанныеЗаполнения;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	ТекПользователь = ПараметрыСеанса.ТекущийПользователь;
	Если НЕ ТипЗнч(Заявка) = Тип("СправочникСсылка.Контрагенты") Тогда
		//Если Ссылка.Заявка.ПометкаУдаления И НЕ Ссылка.Заявка.ПометкаУдаления = Ссылка.ПометкаУдаления Тогда
		//	Сообщить("Невозможно пометить на удаление данную задачу, т.к. документ-основание помечен на удаление.");
		//	Отказ = Истина;	
		//КонецЕсли;
	Иначе
		Если Выполнена И НЕ БюджетныйНаСервере.РольДоступнаСервер("Администратор") И ПометкаУдаления Тогда
			Сообщить("Невозможно пометить на удаление данную задачу, т.к. она уже выполнена.");
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если Новая Тогда
		НаборЗаписейНовыхЗадач = РегистрыСведений.ОтслеживаниеЗаявок.СоздатьНаборЗаписей();
		НаборЗаписейНовыхЗадач.Отбор.Документ.Установить(Ссылка);
		НаборЗаписейНовыхЗадач.Прочитать();
		НаборЗаписейНовыхЗадач.Очистить();
		Запись = НаборЗаписейНовыхЗадач.Добавить();
		Запись.Документ = Ссылка;
		Запись.Пользователь = ТекПользователь;
		НаборЗаписейНовыхЗадач.Записать();
		
		//доставитьPUSH
		ОтправитьPUSH();
		
		//доставить почту
		ОтправитьПочтовоеУведомление();
				
	КонецЕсли;
	
	Если Выполнена ИЛИ ПометкаУдаления Тогда
		НаборЗаписейДелигирование = РегистрыСведений.БП_ДелегированиеЗадач.СоздатьНаборЗаписей();
		НаборЗаписейДелигирование.Отбор.Задача.Установить(Ссылка);
		НаборЗаписейДелигирование.Прочитать();
		НаборЗаписейДелигирование.Очистить();
		НаборЗаписейДелигирование.Записать();
		
		//++саб д1 21.03.18
		//БПСервер.ЗавершитьХронометражПоПредмету(ТекущаяДата(), Заявка);
		
	ИначеЕсли Выполнена = Ложь И ПометкаУдаления = Ложь Тогда
		
		
		
		НаборЗаписейНовыхЗадач = РегистрыСведений.БП_ДелегированиеЗадач.СоздатьНаборЗаписей();
		НаборЗаписейНовыхЗадач.Отбор.Задача.Установить(Ссылка);
		НаборЗаписейНовыхЗадач.Отбор.Замещающий.Установить(Исполнитель);
		НаборЗаписейНовыхЗадач.Отбор.Делигирована.Установить(Ложь);
		НаборЗаписейНовыхЗадач.Прочитать();
		Если НЕ НаборЗаписейНовыхЗадач.Количество() Тогда
			НаборЗаписейНовыхЗадач.Очистить();
			Запись = НаборЗаписейНовыхЗадач.Добавить();
			Запись.Задача = Ссылка;
			Запись.Замещающий = Исполнитель;
			Запись.Автор = Автор;
			Если ЗначениеЗаполнено(БизнесПроцесс) Тогда
				Запись.Инициатор = БизнесПроцесс.Автор;
			ИначеЕсли ТипЗнч(Заявка) = Тип("ДокументСсылка.БП_Оповещение") ИЛИ  ТипЗнч(Заявка) = Тип("ДокументСсылка.БП_Поручение") Тогда
				Запись.Инициатор = Заявка.Автор;
			Иначе
				Запись.Инициатор = Автор;
			КонецЕсли;
			Запись.Делигирована = Ложь;
			Запись.ДатаПеренаправления = Дата;
			Запись.Комментарий = "Базовый исполнитель";
			НаборЗаписейНовыхЗадач.Записать();
		КонецЕсли;
		
	КонецЕсли;
	
	Если (Выполнена И ВРаботе) ИЛИ НЕ ВРаботе Тогда
		БПСервер.ЗавершитьХронометражПоПредмету(ТекущаяДата(), ?(ЗначениеЗаполнено(Заявка), Заявка, Ссылка));
	КонецЕсли;
	
	БПСервер.ЗаписатьТекущуюЗадачуПриЗаписи(ЭтотОбъект, Ложь);
	
	сабОбщегоНазначения.сабПлатКалПриЗаписиОбъектовПриЗаписи(ЭтотОбъект, Ложь)
		
КонецПроцедуры

Процедура ОтправитьПочтовоеУведомление()
	
	//нужна фоновая доставка и фильтр по автовыполненным, иначе зависает жестко
	Возврат; //Белых добавил
	
	// отправка на почту исполнителям
	МассивАдресовПолучателей = Новый Массив;
	
	Если ТипЗнч(Ссылка.Исполнитель) = Тип("СправочникСсылка.ГруппыПользователей") Тогда
		
		Для Каждого ТекСтрокаСостав Из Ссылка.Исполнитель.Состав Цикл
			
			СтрокиАдресовЭП = ТекСтрокаСостав.Пользователь.КонтактнаяИнформация.НайтиСтроки(Новый Структура("Тип", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты));
			
			Если СтрокиАдресовЭП.Количество() И ЗначениеЗаполнено(СтрокиАдресовЭП[0].АдресЭП) Тогда   
				МассивАдресовПолучателей.Добавить(Новый Структура("Адрес, Представление", СтрокиАдресовЭП[0].АдресЭП, ТекСтрокаСостав.Пользователь));
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе  
		СтрокиАдресовЭП = Ссылка.Исполнитель.КонтактнаяИнформация.НайтиСтроки(Новый Структура("Тип", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты));
		
		Если СтрокиАдресовЭП.Количество() И ЗначениеЗаполнено(СтрокиАдресовЭП[0].АдресЭП) Тогда   
			МассивАдресовПолучателей.Добавить(Новый Структура("Адрес, Представление", СтрокиАдресовЭП[0].АдресЭП, Ссылка.Исполнитель));
		КонецЕсли;
		
	КонецЕсли;
	
	Попытка
		УчетнаяЗапись = Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты;
		ПараметрыОтправки = Новый Структура;
		ПараметрыОтправки.Вставить("Кому", МассивАдресовПолучателей);
		ПараметрыОтправки.Вставить("Тема", "Поступила новая задача: " + Ссылка.Заявка + ". " + Ссылка.ТочкаМаршрута);
		ПараметрыОтправки.Вставить("Тело", Ссылка.Описание);
		//ПараметрыОтправки.Вставить("Вложения", Вложения);
		//Если HTML Тогда
		//	ПараметрыОтправки.Вставить("ТипТекста", "HTML");
		//	ПараметрыОтправки.Вставить("ОбрабатыватьТексты", Ложь);
		//КонецЕсли;
		
		УстановитьПривилегированныйРежим(Истина);
		РаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(УчетнаяЗапись, ПараметрыОтправки);
		УстановитьПривилегированныйРежим(Ложь);
	Исключение
		ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ОплатаСервисаЖурналРегистрацииБП.ЗаписатьОшибку(ОписаниеОшибки);
	КонецПопытки;

КонецПроцедуры

Процедура ОтправитьPUSH()
	Если Не ТипЗнч(Исполнитель) = Тип("СправочникСсылка.Пользователи") ИЛИ Автор = Исполнитель Или Час(ТекущаяДата()) > 20 Или Час(ТекущаяДата()) < 8 Тогда
		Возврат;
	КонецЕсли;
	
	//КлючСервера = Константы.сабКлючДляPushУведомлений.Получить();
	КлючСервера = Неопределено;
	
	Если ЗначениеЗаполнено(КлючСервера) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	PushПользователиID.PushId КАК PushId,
		|	PushПользователиID.Пользователь КАК Пользователь
		|ИЗ
		|	РегистрСведений.PushПользователиID КАК PushПользователиID
		|ГДЕ
		|	PushПользователиID.Пользователь В ИЕРАРХИИ(&Пользователь)";
		
		Запрос.УстановитьПараметр("Пользователь", БПСервер.ПолучитьМассивПользователей(Исполнитель));
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Идентификатор = БюджетныйНаСервере.ДеСериализоватьОбъект(Выборка.PushId);
			
			Уведомление = Новый ДоставляемоеУведомление;
			Уведомление.Получатели.Добавить(Идентификатор);
			Уведомление.Заголовок = "Задача " + Константы.ЗаголовокКонфигурации.Получить();
			Уведомление.Текст = ?(Описание = "", Наименование, Описание);
			Уведомление.Данные = Номер;
			
			ДанныеАвторизации = Новый Соответствие; 
			ДанныеАвторизации.Вставить(ТипПодписчикаДоставляемыхУведомлений.FCM, КлючСервера);
			
			Попытка
				
				ОтправкаДоставляемыхУведомлений.Отправить(Уведомление, ДанныеАвторизации);
				
			Исключение
				
			КонецПопытки;
			
		КонецЦикла;
		
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если Выполнена И Не ЗначениеЗаполнено(ДатаИсполнения) Тогда
		ДатаИсполнения = ТекущаяДата();
		Если ТипЗнч(Заявка) = Тип("СправочникСсылка.Контрагенты") Тогда
			ДатаНачала = ДатаИсполнения;
		КонецЕсли;	
		Пользователь = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	
	Если ТипЗнч(Заявка) = Тип("ДокументСсылка.Д_ЗаявкаНаОплату") Тогда
		//СтруктураЗаявки = БюджетныйНаСервере.ВернутьРеквизиты(Заявка, "СуммаДокумента, ТипИсточника, ДатаОплаты");
		ОписаниеБП = "";
		Если ЗначениеЗаполнено(БизнесПроцесс) Тогда
			ОписаниеБП = БизнесПроцесс.Описание;
		КонецЕсли;
		
		Если ТочкаМаршрута = Перечисления.Согласование1ТочкиМаршрута.Действие5 Тогда
			СтруктураЗаявки = ПолучитьСуммуДляОтветственного(Заявка);
			Если СтруктураЗаявки.ЭтоБезнал = Неопределено Тогда
				СтруктураЗаявки.Вставить("ТипИсточника", "");
			Иначе	
				СтруктураЗаявки.Вставить("ТипИсточника", ?(СтруктураЗаявки.ЭтоБезнал, "Безналичный", "Наличный"));
			КонецЕсли;
			ОписаниеКоличество = СтруктураЗаявки.КоличествоПозиций;
		Иначе
			СтруктураЗаявки = БюджетныйНаСервере.ВернутьРеквизиты(Заявка, "СуммаДокумента, ДатаОплаты, ТипИсточника, ВидОперации, Предприятие.ОсновнаяВалютаУчета");
			Если СтруктураЗаявки.ВидОперации = Перечисления.ВидыОперацийРеестраОплат.ОбщийРеестрПлатежей Тогда
				ЕстьБезНал = Ложь; ЕстьНал = Ложь;
				Для каждого ТекСтрока Из Заявка.ЗаявкаБезнал Цикл
					Если ТипЗнч(ТекСтрока.Источник) = Тип("СправочникСсылка.БанковскиеСчета") Тогда
						ЕстьБезНал = Истина;
					Иначе
						ЕстьНал = Истина;
					КонецЕсли;
				КонецЦикла;
				Если ЕстьБезНал И НЕ ЕстьНал Тогда
					СтруктураЗаявки.ТипИсточника = "Безналичный";
				ИначеЕсли НЕ ЕстьБезНал И ЕстьНал Тогда
					СтруктураЗаявки.ТипИсточника = "Наличный";
				Иначе
					СтруктураЗаявки.ТипИсточника = "Безналичный и наличный"; 
				КонецЕсли;
			Иначе
				СтруктураЗаявки.ТипИсточника = ?(СтруктураЗаявки.ТипИсточника = Перечисления.Д_ИсточникиСредств.БезНал, "Безналичный", "Наличный");	
			КонецЕсли;
			ОписаниеКоличество = Заявка.ЗаявкаБезнал.Количество();
		КонецЕсли;
 		
		ОписаниеСумма = " поз. на сумму " + СтруктураЗаявки.СуммаДокумента + " " + СтруктураЗаявки.ПредприятиеОсновнаяВалютаУчета + ".";
		Описание = Строка(СтруктураЗаявки.ТипИсточника) + ", " +  ?(ЗначениеЗаполнено(ОписаниеБП), ОписаниеБП + ", ", "") + Строка(ОписаниеКоличество) + ОписаниеСумма;  
		
		Если Не ЗначениеЗаполнено(Ссылка) И НЕ ЗначениеЗаполнено(СрокВыполнения) Тогда
			СрокВыполнения = СтруктураЗаявки.ДатаОплаты;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Заявка) = Тип("ДокументСсылка.Д_ЗаявкаНаФинансирование") Тогда
		СтруктураЗаявки = БюджетныйНаСервере.ВернутьРеквизиты(Заявка, "Сумма, ТипИсточника, ДатаОплаты, Дата, ЦФО.ОсновнаяВалютаУчета");
		ОписаниеБП = "";
		Если ЗначениеЗаполнено(БизнесПроцесс) Тогда
			ОписаниеБП = БизнесПроцесс.Описание;
		КонецЕсли;
		ОписаниеСумма = " на сумму " + СтруктураЗаявки.Сумма + " " + СтруктураЗаявки.ЦФООсновнаяВалютаУчета + ".";
		Описание = Строка(СтруктураЗаявки.ТипИсточника) + ", " +  ?(ЗначениеЗаполнено(ОписаниеБП), ОписаниеБП + ", ", "") + ОписаниеСумма;  
		Если Не ЗначениеЗаполнено(Ссылка) И НЕ ЗначениеЗаполнено(СрокВыполнения) Тогда
			Если СтруктураЗаявки.ДатаОплаты = Дата('00010101') Тогда
				СрокВыполнения = НачалоДня(СтруктураЗаявки.Дата) + 18*60*60;
			Иначе	
				СрокВыполнения = НачалоДня(СтруктураЗаявки.ДатаОплаты) + 18*60*60;
			КонецЕсли;
		КонецЕсли;
	//ИначеЕсли ТипЗнч(Заявка) = Тип("ДокументСсылка.Д_ЗаявкаНаОтгрузку") Тогда
	//	ОписаниеБП = "";
	//	Если ЗначениеЗаполнено(БизнесПроцесс) Тогда
	//		ОписаниеБП = БизнесПроцесс.Описание;
	//	КонецЕсли;
	//	Стр = БюджетныйНаСервере.ВернутьРеквизиты(Заявка, "Предприятие, Грузополучатель, КоличествоДок, Цена"); 
	//	Описание = ?(ЗначениеЗаполнено(ОписаниеБП), ОписаниеБП + ", ", "") + "С " + Строка(Стр.Предприятие) + " на " + Строка(Стр.Грузополучатель) + ", " + Формат(Стр.КоличествоДок, "ЧДЦ=0") + " по " + Формат(Стр.Цена, "ЧДЦ=0");  
	//ИначеЕсли ТипЗнч(Заявка) = Тип("ДокументСсылка.Д_ЗаявкаНаТорговлю") Тогда
	//	ОписаниеБП = "";
	//	Если ЗначениеЗаполнено(БизнесПроцесс) Тогда
	//		ОписаниеБП = БизнесПроцесс.Описание;
	//	КонецЕсли;
	//	Стр = БюджетныйНаСервере.ВернутьРеквизиты(Заявка, "Предприятие, Контрагент, ФизическийОбъем, Цена, Номенклатура"); 
	//	Описание = ?(ЗначениеЗаполнено(ОписаниеБП), ОписаниеБП + ", ", "") + "С " + Строка(Стр.Предприятие) + " на " + Строка(Стр.Контрагент) + ", " + Строка(Стр.Номенклатура) + " " + Формат(Стр.ФизическийОбъем, "ЧДЦ=0") + " по " + Формат(Стр.Цена, "ЧДЦ=0");  
		
	ИначеЕсли ТипЗнч(Заявка) = Тип("ДокументСсылка.Д_ЗаявкаНаАвансовыйОтчет") Тогда
		ОписаниеБП = "";
		Если ЗначениеЗаполнено(БизнесПроцесс) Тогда
			ОписаниеБП = БизнесПроцесс.Описание;
		КонецЕсли;
		Описание = ?(ЗначениеЗаполнено(ОписаниеБП), ОписаниеБП + ", ", "") + Строка(Заявка.Затраты.Количество()) + " поз. на сумму " + Формат(Заявка.СуммаДокумента, "ЧДЦ=0") + " руб.";  
	//ИначеЕсли ТипЗнч(Заявка) = Тип("ДокументСсылка.Д_ОбращенияВТехПоддержку") Тогда
	//	Если Не ЗначениеЗаполнено(Ссылка) Тогда
	//		СрокОбращения = Заявка.ПожеланиеКСроку;
	//		Если ЗначениеЗаполнено(СрокОбращения) И НЕ ЗначениеЗаполнено(СрокВыполнения) Тогда
	//			СрокВыполнения = СрокОбращения;
	//		КонецЕсли;
	//	КонецЕсли;
	КонецЕсли;
	
	Если Ссылка.Пустая() Тогда
		ДатаНачала = ?(ДатаНачала = Дата('00010101'), ТекущаяДата(), ДатаНачала);
		Новая = Истина;
		Если Не ЗначениеЗаполнено(СрокВыполнения) И НЕ ТипЗнч(Заявка) = Тип("ДокументСсылка.БП_Оповещение") Тогда
			ДниДоСрока = 0;
			РабочийДень = Ложь;
			Пока НЕ РабочийДень = Истина Цикл
				ГодКалендаря = Год(ДатаНачала);		
				Календарь = Справочники.Календари.НайтиПоНаименованию(Формат(ГодКалендаря,"ЧГ=0"), Истина);
				РабочийДень = БПСервер.ПолучитьПризнакРабочегоДня(Календарь,ГодКалендаря,НачалоДня(ДатаНачала + (ДниДоСрока + 1) * 24 * 60 * 60));
				Если РабочийДень = Неопределено Тогда
					ДниДоСрока = 1;
					Прервать;	
				КонецЕсли;
				ДниДоСрока = ДниДоСрока + 1;
			КонецЦикла;
			СрокВыполнения = ДатаНачала + ДниДоСрока * 24*60*60;  
		КонецЕсли;
	Иначе
		Новая = Ложь;	
	КонецЕсли;

	
КонецПроцедуры

Функция ПолучитьСуммуДляОтветственного(Заявка)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СУММА(Д_ЗаявкаНаОплатуЗаявкаБезнал.СуммаДДС) КАК СуммаДокумента,
	               |	КОЛИЧЕСТВО(Д_ЗаявкаНаОплатуЗаявкаБезнал.НомерСтроки) КАК КоличествоПозиций,
	               |	Д_ЗаявкаНаОплатуЗаявкаБезнал.Ссылка.ДатаОплаты КАК ДатаОплаты,
	               |	МАКСИМУМ(ТИПЗНАЧЕНИЯ(Д_ЗаявкаНаОплатуЗаявкаБезнал.Источник) = ТИП(Справочник.БанковскиеСчета)) КАК ЭтоБезнал,
	               |	Д_ИсточникППСрезПоследних.Предприятие.ОсновнаяВалютаУчета КАК ПредприятиеОсновнаяВалютаУчета
	               |ИЗ
	               |	Документ.Д_ЗаявкаНаОплату.ЗаявкаБезнал КАК Д_ЗаявкаНаОплатуЗаявкаБезнал
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Д_ИсточникПП.СрезПоследних(&ДатаЗаявки, ОтветственноеЛицо В (&ТекущийПользователь)) КАК Д_ИсточникППСрезПоследних
	               |		ПО (Д_ЗаявкаНаОплатуЗаявкаБезнал.Источник = Д_ИсточникППСрезПоследних.БанковскиеСчета
	               |				ИЛИ Д_ЗаявкаНаОплатуЗаявкаБезнал.БанковскийСчет = Д_ИсточникППСрезПоследних.БанковскиеСчета)
	               |ГДЕ
	               |	Д_ЗаявкаНаОплатуЗаявкаБезнал.Ссылка = &Ссылка
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Д_ЗаявкаНаОплатуЗаявкаБезнал.Ссылка.ДатаОплаты,
	               |	Д_ИсточникППСрезПоследних.Предприятие.ОсновнаяВалютаУчета";
	
	Запрос.УстановитьПараметр("Ссылка", Заявка);
	Запрос.УстановитьПараметр("ДатаЗаявки", Заявка.Дата);
	Запрос.УстановитьПараметр("ТекущийПользователь", Исполнитель);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Возврат Новый Структура("СуммаДокумента, КоличествоПозиций, ЭтоБезнал, ДатаОплаты, ПредприятиеОсновнаяВалютаУчета", Выборка.СуммаДокумента, Выборка.КоличествоПозиций, Выборка.ЭтоБезнал, Выборка.ДатаОплаты, Выборка.ПредприятиеОсновнаяВалютаУчета);	
	КонецЦикла;
	
	Возврат Новый Структура("СуммаДокумента, КоличествоПозиций, ЭтоБезнал, ДатаОплаты, ПредприятиеОсновнаяВалютаУчета", 0, 0, Неопределено, '00010101', УЧ_Сервер.НациональнаяВалюта());
	
КонецФункции // ()

Процедура ВыполнитьЗадачу() Экспорт
	Выполнена = Истина;
	Записать();
КонецПроцедуры

